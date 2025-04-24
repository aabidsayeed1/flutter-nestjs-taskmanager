import { LoggingMiddleware } from './logRequest.middleware';
import { WinstonLogger } from '../logger/winston-logger.service';
import { TraceContext } from './trace.context';
import { v7 as uuidv7 } from 'uuid';
import { Request, Response } from 'express';
import { ParamsDictionary } from 'express-serve-static-core';
import { ParsedQs } from 'qs';

jest.mock('../logger/winston-logger.service');
jest.mock('./trace.context');
jest.mock('uuid');

describe('LoggingMiddleware', () => {
	let middleware: LoggingMiddleware;
	let mockLogger: jest.Mocked<WinstonLogger>;
	let mockRequest: jest.Mocked<
		Request<ParamsDictionary, any, any, ParsedQs, Record<string, any>>
	>;
	let mockResponse: jest.Mocked<Response>;
	let mockNext: jest.Mock;

	beforeEach(() => {
		mockLogger = {
			log: jest.fn(),
			error: jest.fn(),
			warn: jest.fn()
		} as any;

		middleware = new LoggingMiddleware(mockLogger);

		mockRequest = {
			headers: {},
			cookies: {},
			method: 'GET',
			originalUrl: '/test',
			ip: '127.0.0.1'
		} as any;

		mockResponse = {
			setHeader: jest.fn(),
			on: jest.fn(),
			statusCode: 200
		} as any;

		mockNext = jest.fn();

		jest.mocked(uuidv7).mockReturnValue('mock-uuid');
		jest.mocked(TraceContext.run).mockImplementation(fn => fn());
	});

	it('should set trace and session IDs', () => {
		middleware.use(mockRequest, mockResponse, mockNext);

		expect(TraceContext.setTraceId).toHaveBeenCalledWith('mock-uuid');
		expect(TraceContext.setSessionId).toHaveBeenCalledWith('mock-uuid');
		expect(mockRequest.headers['trace-id']).toBe('mock-uuid');
		expect(mockRequest.headers['session-id']).toBe('mock-uuid');
		expect(mockResponse.setHeader).toHaveBeenCalledWith(
			'trace-id',
			'mock-uuid'
		);
		expect(mockResponse.setHeader).toHaveBeenCalledWith(
			'session-id',
			'mock-uuid'
		);
	});

	it('should use existing trace and session IDs if available', () => {
		mockRequest.headers['trace-id'] = 'existing-trace-id';
		mockRequest.headers['session-id'] = 'existing-session-id';

		middleware.use(mockRequest, mockResponse, mockNext);

		expect(TraceContext.setTraceId).toHaveBeenCalledWith(
			'existing-trace-id'
		);
		expect(TraceContext.setSessionId).toHaveBeenCalledWith(
			'existing-session-id'
		);
	});

	it('should log requests and call next', () => {
		middleware.use(mockRequest, mockResponse, mockNext);

		expect(mockNext).toHaveBeenCalled();
		expect(mockResponse.on).toHaveBeenCalledWith(
			'finish',
			expect.any(Function)
		);
	});

	it('should log successful requests', () => {
		middleware.use(mockRequest, mockResponse, mockNext);

		const finishCallback = jest.mocked(mockResponse.on).mock
			.calls[0][1] as () => void;
		mockResponse.statusCode = 200;

		finishCallback();

		expect(mockLogger.log).toHaveBeenCalledWith(
			expect.stringContaining('[Status: 200]'),
			expect.objectContaining({ statusCode: 200 })
		);
	});

	it('should log and report client errors', () => {
		middleware.use(mockRequest, mockResponse, mockNext);

		const finishCallback = jest.mocked(mockResponse.on).mock
			.calls[0][1] as () => void;
		mockResponse.statusCode = 400;

		finishCallback();

		expect(mockLogger.warn).toHaveBeenCalledWith(
			expect.stringContaining('[Status: 400]'),
			expect.objectContaining({ statusCode: 400 })
		);
	});

	it('should log and report server errors', () => {
		middleware.use(mockRequest, mockResponse, mockNext);

		const finishCallback = jest.mocked(mockResponse.on).mock
			.calls[0][1] as () => void;
		mockResponse.statusCode = 500;

		finishCallback();

		expect(mockLogger.error).toHaveBeenCalledWith(
			expect.stringContaining('[Status: 500]'),
			expect.objectContaining({ statusCode: 500 })
		);
	});
});
