import { Test, TestingModule } from '@nestjs/testing';
import { ConfigService } from '@nestjs/config';
import { WinstonLogger } from './winston-logger.service';
import * as winston from 'winston';
import { TraceContext } from '../middlewares/trace.context';

jest.mock('winston', () => ({
	createLogger: jest.fn().mockReturnValue({
		info: jest.fn(),
		error: jest.fn(),
		warn: jest.fn(),
		debug: jest.fn(),
		verbose: jest.fn()
	}),
	format: {
		combine: jest.fn(),
		timestamp: jest.fn(),
		json: jest.fn(),
		errors: jest.fn(),
		splat: jest.fn()
	},
	transports: {
		File: jest.fn()
	}
}));

jest.mock('fs', () => ({
	statSync: jest.fn(),
	renameSync: jest.fn(),
	stat: jest.fn((path, callback) => callback(null, { size: 0 }))
}));

jest.mock('../middlewares/trace.context', () => ({
	TraceContext: {
		getTraceId: jest.fn(),
		getSessionId: jest.fn()
	}
}));

describe('WinstonLogger', () => {
	let service: WinstonLogger;
	let mockConfigService: jest.Mocked<ConfigService>;

	beforeEach(async () => {
		mockConfigService = {
			get: jest.fn()
		} as any;

		const module: TestingModule = await Test.createTestingModule({
			providers: [
				WinstonLogger,
				{
					provide: ConfigService,
					useValue: mockConfigService
				}
			]
		}).compile();

		service = module.get<WinstonLogger>(WinstonLogger);
	});

	it('should be defined', () => {
		expect(service).toBeDefined();
	});

	describe('logging methods', () => {
		const testCases: Array<{
			method: keyof WinstonLogger;
			level: keyof winston.Logger;
		}> = [
			{ method: 'log', level: 'info' },
			{ method: 'error', level: 'error' },
			{ method: 'warn', level: 'warn' },
			{ method: 'debug', level: 'debug' },
			{ method: 'verbose', level: 'verbose' }
		];

		testCases.forEach(({ method, level }) => {
			it(`should call winston  method with correct parameters`, () => {
				const message = 'Test message';
				const context = { key: 'value' };
				(TraceContext.getTraceId as jest.Mock).mockReturnValue(
					'trace-id'
				);
				(TraceContext.getSessionId as jest.Mock).mockReturnValue(
					'session-id'
				);

				service[method](message, context);

				expect((service['logger'] as any)[level]).toHaveBeenCalledWith({
					traceID: 'trace-id',
					sessionID: 'session-id',
					message,
					context
				});
			});
		});
	});
});
