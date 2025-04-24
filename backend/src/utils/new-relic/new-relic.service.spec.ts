import { Test, TestingModule } from '@nestjs/testing';
import { NewRelicService } from './new-relic.service';
import * as newrelic from 'newrelic';

jest.mock('newrelic', () => ({
	addCustomAttribute: jest.fn(),
	recordMetric: jest.fn(),
	startSegment: jest.fn(),
	noticeError: jest.fn()
}));

describe('NewRelicService', () => {
	let service: NewRelicService;

	beforeEach(async () => {
		const module: TestingModule = await Test.createTestingModule({
			providers: [NewRelicService]
		}).compile();

		service = module.get<NewRelicService>(NewRelicService);
	});

	it('should be defined', () => {
		expect(service).toBeDefined();
	});

	describe('addCustomAttribute', () => {
		it('should call newrelic.addCustomAttribute with correct parameters', () => {
			service.addCustomAttribute('key', 'value');
			expect(newrelic.addCustomAttribute).toHaveBeenCalledWith(
				'key',
				'value'
			);
		});
	});

	describe('recordMetric', () => {
		it('should call newrelic.recordMetric with correct parameters', () => {
			service.recordMetric('metricName', 10);
			expect(newrelic.recordMetric).toHaveBeenCalledWith(
				'metricName',
				10
			);
		});
	});

	describe('startSegment', () => {
		it('should call newrelic.startSegment with correct parameters', async () => {
			const handler = jest.fn().mockResolvedValue('result');
			(newrelic.startSegment as jest.Mock).mockImplementation(
				(name, record, fn) => fn()
			);

			const result = await service.startSegment(
				'segmentName',
				true,
				handler
			);

			expect(newrelic.startSegment).toHaveBeenCalledWith(
				'segmentName',
				true,
				expect.any(Function)
			);
			expect(handler).toHaveBeenCalled();
			expect(result).toBe('result');
		});
	});

	describe('noticeError', () => {
		it('should call newrelic.noticeError with correct parameters', () => {
			const error = new Error('Test error');
			service.noticeError(error);
			expect(newrelic.noticeError).toHaveBeenCalledWith(error);
		});
	});
});
