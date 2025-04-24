import {
	applyDecorators,
	BadRequestException,
	CallHandler,
	ExecutionContext,
	Injectable,
	InternalServerErrorException,
	NestInterceptor,
	Type
} from '@nestjs/common';
import {
	ApiExtraModels,
	ApiInternalServerErrorResponse,
	ApiOkResponse,
	ApiProperty,
	getSchemaPath
} from '@nestjs/swagger';
import { catchError, map, Observable, throwError } from 'rxjs';
import { VALIDATION_FAILED_MESSAGE } from '../messages/validations';

export function ApiOkGenericResponse<TModel extends Type<any>>(
	model: TModel,
	message: string,
	isArray: boolean = false
) {
	return applyDecorators(
		ApiExtraModels(ResultOk, model),
		ApiOkResponse({
			schema: {
				allOf: [
					{ $ref: getSchemaPath(ResultOk) },
					{
						properties: {
							entity: isArray
								? {
										type: 'array',
										items: {
											$ref: getSchemaPath(model)
										}
									}
								: {
										$ref: getSchemaPath(model)
									},

							message: {
								type: 'string',
								example: message || 'Operation successful'
							}
						}
					}
				]
			}
		})
	);
}

export function ApiErrorGenericResponse(message: string) {
	return applyDecorators(
		ApiExtraModels(ResultError), // Register the ResultError model
		ApiInternalServerErrorResponse({
			description: 'Something went wrong',
			schema: {
				allOf: [
					{ $ref: getSchemaPath(ResultError) },
					{
						properties: {
							message: {
								type: 'string',
								example: message || 'Operation failed'
							}
						}
					}
				]
			}
		})
	);
}
export class ResultOk<T> {
	@ApiProperty({
		example: true,
		description: 'Indicates the success of the operation'
	})
	status!: boolean;

	@ApiProperty({
		//example: 'Operation successful',
		type: 'string',
		description: 'A descriptive success message'
	})
	message!: string;

	@ApiProperty({
		description: 'The data payload of the response',
		type: 'object'
	})
	entity!: T;
}

export class ResultError {
	@ApiProperty({
		example: false,
		description: 'Indicates the failure of the operation'
	})
	status!: boolean;

	@ApiProperty({
		example: 'Operation failed',
		description: 'A descriptive error message'
	})
	message!: string;

	@ApiProperty({
		example: { field: 'Error description' },
		description: 'Details of the error(s)'
	})
	errors!: string[] | Record<string, any>;
}

function getSuccessMessage(method: 'GET' | 'POST' | 'PUT' | 'DELETE') {
	const responses = {
		GET: 'Resource fetched successfully.',
		POST: 'Resource created successfully.',
		PUT: 'Resource updated successfully.',
		PATCH: 'Resource updated successfully.',
		DELETE: 'Resource deleted successfully.'
	};
	return responses[method] ?? 'Operation successful';
}

@Injectable()
export class ResultTransformInterceptor implements NestInterceptor {
	intercept(context: ExecutionContext, next: CallHandler): Observable<any> {
		const request = context.switchToHttp().getRequest();
		const handler = context.getHandler();
		const operationType = request.body.operationType; // Assume this contains the operation type

		if (Reflect.getMetadata('skipInterceptor', handler)) {
			return next.handle(); // Skip interception
		}

		return next.handle().pipe(
			map(data => {
				if (data) {
					return {
						status: true,
						message: getSuccessMessage(request.method),
						entity: data
					};
				}

				return {
					status: false,
					message: 'No data returned',
					errors: null
				};
			}),
			catchError(error => {
				// Handle DTO Validation Errors

				if (
					error instanceof BadRequestException &&
					error.message === VALIDATION_FAILED_MESSAGE
				) {
					const errorResponse = error.getResponse() as {
						message: string;
						errors: Record<string, string[]>;
					};

					return throwError(
						() =>
							new BadRequestException({
								status: false,
								message: errorResponse.errors
								// errors: errorResponse.errors
							})
					);
				}

				return throwError(
					() =>
						new InternalServerErrorException({
							status: false,
							message: error.message,
							errors: error.message
						})
				);
			})
		);
	}
}
