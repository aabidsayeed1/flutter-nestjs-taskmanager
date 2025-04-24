import { Module } from '@nestjs/common';
import { Test, TestingModule } from '@nestjs/testing';
import { MiddlewareModule } from './middlewares.module';
import { LoggerModule } from '../logger/logger-module';
import { LoggingMiddleware } from './logRequest.middleware';
import { RateLimitingMiddleware } from './rate-limiting.middleware';
import { WinstonLogger } from '../logger/winston-logger.service';

// Mock WinstonLogger
class MockWinstonLogger {
	log = jest.fn();
	error = jest.fn();
	warn = jest.fn();
	debug = jest.fn();
	verbose = jest.fn();
}

// Mock LoggerModule
@Module({
	providers: [
		{
			provide: WinstonLogger,
			useClass: MockWinstonLogger
		}
	],
	exports: [WinstonLogger]
})
class MockLoggerModule {}

// Mock RateLimitingMiddleware
class MockRateLimitingMiddleware {
	use = jest.fn().mockImplementation((req, res, next) => next());
}

describe('MiddlewareModule', () => {
	let module: TestingModule;

	beforeEach(async () => {
		module = await Test.createTestingModule({
			imports: [MiddlewareModule]
		})
			.overrideModule(LoggerModule)
			.useModule(MockLoggerModule)
			.overrideProvider(RateLimitingMiddleware)
			.useClass(MockRateLimitingMiddleware)
			.compile();
	});

	it('should be defined', () => {
		expect(module).toBeDefined();
	});

	it('should import LoggerModule', () => {
		const winstonLogger = module.get(WinstonLogger);
		expect(winstonLogger).toBeDefined();
	});

	it('should provide LoggingMiddleware', () => {
		const loggingMiddleware = module.get(LoggingMiddleware);
		expect(loggingMiddleware).toBeDefined();
	});

	it('should provide RateLimitingMiddleware', () => {
		const rateLimitingMiddleware = module.get(RateLimitingMiddleware);
		expect(rateLimitingMiddleware).toBeDefined();
		expect(rateLimitingMiddleware).toBeInstanceOf(
			MockRateLimitingMiddleware
		);
	});

	it('should export LoggingMiddleware', () => {
		const exportedProviders = Reflect.getMetadata(
			'exports',
			MiddlewareModule
		);
		expect(exportedProviders).toContain(LoggingMiddleware);
	});

	it('should export RateLimitingMiddleware', () => {
		const exportedProviders = Reflect.getMetadata(
			'exports',
			MiddlewareModule
		);
		expect(exportedProviders).toContain(RateLimitingMiddleware);
	});
});
