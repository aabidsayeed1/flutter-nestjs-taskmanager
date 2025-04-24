import { Test, TestingModule } from '@nestjs/testing';
import { NewRelicModule } from './new-relic.module';
import { NewRelicService } from './new-relic.service';
import { ConfigModule } from '@nestjs/config';

jest.mock(
	'newrelic',
	() => ({
		addCustomAttribute: jest.fn(),
		recordMetric: jest.fn(),
		startSegment: jest.fn(),
		noticeError: jest.fn()
	}),
	{ virtual: true }
);

describe('NewRelicModule', () => {
	let module: TestingModule;

	beforeEach(async () => {
		module = await Test.createTestingModule({
			imports: [NewRelicModule, ConfigModule.forRoot()]
		}).compile();
	});

	it('should be defined', () => {
		expect(module).toBeDefined();
	});

	it('should import ConfigModule', () => {
		const configModule = module.get(ConfigModule);
		expect(configModule).toBeDefined();
	});

	it('should provide NewRelicService', () => {
		const newRelicService = module.get(NewRelicService);
		expect(newRelicService).toBeInstanceOf(NewRelicService);
	});

	it('should export NewRelicService', () => {
		const exportedProviders = Reflect.getMetadata(
			'exports',
			NewRelicModule
		);
		expect(exportedProviders).toContain(NewRelicService);
	});
});
