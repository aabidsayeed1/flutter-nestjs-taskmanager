import { Test, TestingModule } from '@nestjs/testing';
import { LoggerModule } from './logger-module';
import { WinstonLogger } from './winston-logger.service';
import { ConfigModule, ConfigService } from '@nestjs/config';

describe('LoggerModule', () => {
	let module: TestingModule;

	beforeEach(async () => {
		const mockConfigService = {
			get: jest.fn().mockImplementation((key: string) => {
				// Mock the necessary config values here
				if (key === 'aws.cloudwatch.region') return 'test-region';
				if (key === 'aws.cloudwatch.logGroupName')
					return 'test-log-group';
				if (key === 'aws.cloudwatch.logStreamName')
					return 'test-log-stream';
				if (key === 'aws.cloudwatch.accessKeyId')
					return 'test-access-key';
				if (key === 'aws.cloudwatch.secretKey')
					return 'test-secret-key';
				return null;
			})
		};

		module = await Test.createTestingModule({
			imports: [
				LoggerModule,
				ConfigModule.forRoot({
					isGlobal: true
				})
			]
		})
			.overrideProvider(ConfigService)
			.useValue(mockConfigService)
			.compile();
	});

	it('should be defined', () => {
		expect(module).toBeDefined();
	});

	it('should provide WinstonLogger', () => {
		const winstonLogger = module.get(WinstonLogger);
		expect(winstonLogger).toBeInstanceOf(WinstonLogger);
	});

	it('should export WinstonLogger', () => {
		const exportedProviders = Reflect.getMetadata('exports', LoggerModule);
		expect(exportedProviders).toContain(WinstonLogger);
	});
});
