import { Global, Module } from '@nestjs/common';
import { LoggerModule } from '../logger/logger-module';
import { LoggingMiddleware } from './logRequest.middleware';
import { RateLimitingMiddleware } from './rate-limiting.middleware';

@Global()
@Module({
	imports: [LoggerModule],
	providers: [LoggingMiddleware, RateLimitingMiddleware],
	exports: [LoggingMiddleware, RateLimitingMiddleware]
})
export class MiddlewareModule {}
