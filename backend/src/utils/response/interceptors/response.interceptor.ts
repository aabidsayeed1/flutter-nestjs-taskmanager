import {
	CUSTOM_RESPONSE_DTO_KEY,
	CUSTOM_RESPONSE_KEY
} from '@/utils/response/constants/response.constant';
import { ResponseDto } from '@/utils/response/dto/response.dto';
import {
	CallHandler,
	ExecutionContext,
	HttpException,
	HttpStatus,
	Injectable,
	NestInterceptor
} from '@nestjs/common';
import { Reflector } from '@nestjs/core';
import { ClassConstructor, plainToInstance } from 'class-transformer';
import { Response } from 'express';
import { Observable, of } from 'rxjs';
import { catchError, map } from 'rxjs/operators';

@Injectable()
export class ResponseInterceptor<T>
	implements NestInterceptor<T, ResponseDto<T>>
{
	constructor(private readonly reflector: Reflector) {}

	intercept(
		context: ExecutionContext,
		next: CallHandler
	): Observable<ResponseDto<T>> {
		const message = this.reflector.get<string>(
			CUSTOM_RESPONSE_KEY,
			context.getHandler()
		);
		const dto = this.reflector.get<ClassConstructor<any>>(
			CUSTOM_RESPONSE_DTO_KEY,
			context.getHandler()
		);
		const response = context.switchToHttp().getResponse<Response>();

		return next.handle().pipe(
			map(data => {
				const transformedData = dto
					? plainToInstance(dto, data, {
							excludeExtraneousValues: true
						})
					: data;
				const response: ResponseDto<T> = {
					success: true,
					message: message || 'Request successfully processed',
					entity: transformedData,
					statusCode: context.switchToHttp().getResponse().statusCode
				};
				return response;
			}),
			catchError(error => {
				const status =
					error instanceof HttpException
						? error.getStatus()
						: HttpStatus.INTERNAL_SERVER_ERROR;
				response.status(status);

				const errorResult: ResponseDto<null> = {
					success: false,
					message: error.message || 'An error occurred',
					errorResponse: error.response || error,
					statusCode: status
				};

				// Return the error response without re-throwing HttpException
				return of(errorResult as ResponseDto<T>);
			})
		);
	}
}
