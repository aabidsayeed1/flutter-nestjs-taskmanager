import {
	ExceptionFilter,
	Catch,
	ArgumentsHost,
	HttpException,
	BadRequestException
} from '@nestjs/common';
import { Request, Response } from 'express';
import { WinstonLogger } from './logger/winston-logger.service';

@Catch(HttpException)
export class HttpExceptionFilter implements ExceptionFilter {
	constructor(private readonly logger: WinstonLogger) {}

	catch(exception: HttpException, host: ArgumentsHost) {
		const ctx = host.switchToHttp();
		const response = ctx.getResponse<Response>();
		const request = ctx.getRequest<Request>();
		const status = exception.getStatus();

		let errorResponse: any = {
			statusCode: status,
			timestamp: new Date().toISOString(),
			path: request.url,
			message: exception.message
		};

		// Check if the exception is a BadRequestException (which is thrown for DTO validation errors)
		if (exception instanceof BadRequestException) {
			const validationErrors = exception.getResponse();

			// If it's a validation error, use the original error structure
			if (
				typeof validationErrors === 'object' &&
				'message' in validationErrors
			) {
				errorResponse = {
					...errorResponse,
					message: 'Validation failed',
					errors: validationErrors['message']
				};
			}
		}

		const logObject = {
			method: request.method,
			url: request.url,
			headers: request.headers,
			body: request.body,
			params: request.params,
			query: request.query,
			ip: request.ip,
			statusCode: status
		};

		this.logger.error(`HTTP Exception: ${exception.message}`, logObject);

		response.status(status).json(errorResponse);
	}
}
