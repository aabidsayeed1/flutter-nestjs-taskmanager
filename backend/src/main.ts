import { BadRequestException, ValidationPipe } from '@nestjs/common';
import { ConfigService } from '@nestjs/config';
import { NestFactory } from '@nestjs/core';
import { ValidationError } from 'class-validator';
import cookieParser from 'cookie-parser';
import helmet from 'helmet';
import 'newrelic';
import { AppModule } from './app.module';
import { ApiDocumentationBase } from './base/api-documentation-base';
import { HttpExceptionFilter } from './utils/http-exception.filter';
import { WinstonLogger } from './utils/logger/winston-logger.service';
import { VALIDATION_FAILED_MESSAGE } from './utils/messages/validations';
import { SanitizeHtmlPipe } from './utils/sanitizar/sanitize-html.pipe';

export async function bootstrap() {
	const app = await NestFactory.create(
		AppModule.register({ isSqsEnabled: false })
	);

	app.setGlobalPrefix('api');
	app.useLogger(app.get(WinstonLogger));
	app.use(cookieParser());

	app.use(
		helmet({
			contentSecurityPolicy: {
				directives: {
					defaultSrc: ["'self'"],
					scriptSrc: ["'self'", 'trusted-scripts.com'],
					styleSrc: ["'self'", 'trusted-styles.com'],
					imgSrc: ["'self'", 'data:', 'trusted-images.com'],
					connectSrc: ["'self'", 'trusted-api.com'],
					fontSrc: ["'self'", 'trusted-fonts.com'],
					reportUri: '/csp-report' // Set the report URI here
				}
			}
		})
	);

	app.useGlobalFilters(new HttpExceptionFilter(app.get(WinstonLogger)));
	app.useGlobalPipes(new SanitizeHtmlPipe());
	app.useGlobalPipes(
		new ValidationPipe({
			whitelist: true,
			forbidNonWhitelisted: true,
			transform: true,
			exceptionFactory: (errors: ValidationError[]) => {
				const formattedErrors = formatValidationErrors(errors);

				return new BadRequestException({
					status: false,
					message: VALIDATION_FAILED_MESSAGE,
					errors: formattedErrors
				});
			}
		})
	);

	const configService = app.get(ConfigService);

	app.enableCors({
		origin: configService?.get<any>('app.allowedHosts'),
		methods: 'GET,POST,PUT,DELETE,OPTIONS',
		allowedHeaders: 'Content-Type, Authorization'
	});

	// Initializing Swagger
	ApiDocumentationBase.initApiDocumentation(app);

	const port = configService?.get<number>('app.apiPort') ?? 8000;
	console.log('Port is at', port);

	await app.listen(port);
	return app;

	function formatValidationErrors(errors: ValidationError[]): any {
		const formattedErrors: any = {};

		errors.forEach(error => {
			if (error.children && error.children.length > 0) {
				formattedErrors[error.property] = formatValidationErrors(
					error.children
				);
			} else {
				formattedErrors[error.property] = Object.values(
					error.constraints || {}
				);
			}
		});

		return formattedErrors;
	}
}

bootstrap();
