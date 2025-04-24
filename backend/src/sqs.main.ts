import { ValidationPipe } from '@nestjs/common';
import { ConfigService } from '@nestjs/config';
import { NestFactory } from '@nestjs/core';
import helmet from 'helmet';
import { AppModule } from './app.module';
import { ApiDocumentationBase } from './base/api-documentation-base';
import { HttpExceptionFilter } from './utils/http-exception.filter';
import { WinstonLogger } from './utils/logger/winston-logger.service';
// import { SanitizeHtmlPipe } from './utils/sanitizar/sanitize-html.pipe';
export async function bootstrap() {
	const app = await NestFactory.create(
		AppModule.register({ isSqsEnabled: true })
	);
	app.setGlobalPrefix('api');
	const configService = app.get(ConfigService);
	app.useLogger(app.get(WinstonLogger));
	// app.use(cookieParser());
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
	// app.useGlobalPipes(new SanitizeHtmlPipe());
	app.useGlobalPipes(
		new ValidationPipe({
			whitelist: true,
			forbidNonWhitelisted: true,
			transform: true
		})
	);
	app.enableCors({
		origin: configService?.get<any>('app.allowedHosts'),
		methods: 'GET,POST,PUT,DELETE,OPTIONS',
		allowedHeaders: 'Content-Type, Authorization'
	});
	// Initializing Swagger
	ApiDocumentationBase.initApiDocumentation(app);
	const port = configService?.get<number>('app.sqsPort') ?? 8000;
	console.log('Port is at', port);
	await app.listen(port);
	return app;
}
bootstrap();