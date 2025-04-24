import { Test, TestingModule } from '@nestjs/testing';
import { HttpException, HttpStatus, ArgumentsHost } from '@nestjs/common';
import { HttpExceptionFilter } from './http-exception.filter';
import { WinstonLogger } from './logger/winston-logger.service';
import { createMocks } from 'node-mocks-http';

describe('HttpExceptionFilter', () => {
	let filter: HttpExceptionFilter;
	let mockLogger: jest.Mocked<WinstonLogger>;

	beforeEach(async () => {
		mockLogger = {
			error: jest.fn()
		} as any;

		const module: TestingModule = await Test.createTestingModule({
			providers: [
				HttpExceptionFilter,
				{
					provide: WinstonLogger,
					useValue: mockLogger
				}
			]
		}).compile();

		filter = module.get<HttpExceptionFilter>(HttpExceptionFilter);
	});

	it('should be defined', () => {
		expect(filter).toBeDefined();
	});

	it('should catch HTTP exception and return proper response', () => {
		const { req, res } = createMocks({
			method: 'GET',
			url: '/test'
		});

		const exception = new HttpException(
			'Test exception',
			HttpStatus.BAD_REQUEST
		);
		const host = {
			switchToHttp: () => ({
				getResponse: () => res,
				getRequest: () => req
			})
		} as ArgumentsHost;

		filter.catch(exception, host);

		expect(res._getStatusCode()).toBe(HttpStatus.BAD_REQUEST);
		expect(JSON.parse(res._getData())).toEqual(
			expect.objectContaining({
				statusCode: HttpStatus.BAD_REQUEST,
				message: 'Test exception',
				path: '/test'
			})
		);
	});

	it('should log error with correct information', () => {
		const { req, res } = createMocks({
			method: 'POST',
			url: '/test',
			body: { key: 'value' },
			params: { id: '1' },
			query: { filter: 'active' }
		});

		const exception = new HttpException(
			'Test exception',
			HttpStatus.INTERNAL_SERVER_ERROR
		);
		const host = {
			switchToHttp: () => ({
				getResponse: () => res,
				getRequest: () => req
			})
		} as ArgumentsHost;

		filter.catch(exception, host);

		expect(mockLogger.error).toHaveBeenCalledWith(
			'HTTP Exception: Test exception',
			expect.objectContaining({
				method: 'POST',
				url: '/test',
				body: { key: 'value' },
				params: { id: '1' },
				query: { filter: 'active' },
				statusCode: HttpStatus.INTERNAL_SERVER_ERROR
			})
		);
	});

	it('should handle different HTTP status codes', () => {
		const testCases = [
			{ status: HttpStatus.NOT_FOUND, message: 'Not Found' },
			{ status: HttpStatus.FORBIDDEN, message: 'Forbidden' },
			{ status: HttpStatus.UNAUTHORIZED, message: 'Unauthorized' }
		];

		testCases.forEach(({ status, message }) => {
			const { req, res } = createMocks({
				method: 'GET',
				url: '/test'
			});

			const exception = new HttpException(message, status);
			const host = {
				switchToHttp: () => ({
					getResponse: () => res,
					getRequest: () => req
				})
			} as ArgumentsHost;

			filter.catch(exception, host);

			expect(res._getStatusCode()).toBe(status);
			expect(JSON.parse(res._getData())).toEqual(
				expect.objectContaining({
					statusCode: status,
					message: message
				})
			);
		});
	});
});
