import { Test, TestingModule } from '@nestjs/testing';
import { ConfigService } from '@nestjs/config';
import { RateLimitingMiddleware } from './rate-limiting.middleware';
import { RateLimiterMemory, RateLimiterRes } from 'rate-limiter-flexible';
import * as geoip from 'geoip-lite';
import { Request, Response } from 'express';

jest.mock('rate-limiter-flexible');
jest.mock('geoip-lite');

describe('RateLimitingMiddleware', () => {
	let middleware: RateLimitingMiddleware;
	let mockConfigService: jest.Mocked<ConfigService>;
	let mockRequest: Partial<Request>;
	let mockResponse: Partial<Response>;
	let mockNext: jest.Mock;

	beforeEach(async () => {
		mockConfigService = {
			get: jest.fn()
		} as any;

		const module: TestingModule = await Test.createTestingModule({
			providers: [
				RateLimitingMiddleware,
				{
					provide: ConfigService,
					useValue: mockConfigService
				}
			]
		}).compile();

		mockRequest = {
			ip: '127.0.0.1',
			path: '/test'
		};

		mockResponse = {
			set: jest.fn()
		};

		mockNext = jest.fn();

		(geoip.lookup as jest.Mock).mockReturnValue({ country: 'US' });

		// Reset mocks before each test
		jest.clearAllMocks();

		// Recreate the middleware instance before each test
		middleware = module.get<RateLimitingMiddleware>(RateLimitingMiddleware);
	});

	it('should be defined', () => {
		expect(middleware).toBeDefined();
	});

	it('should allow requests from non-blacklisted IPs', async () => {
		mockConfigService.get.mockReturnValue([]);
		await middleware.use(
			mockRequest as Request,
			mockResponse as Response,
			mockNext
		);
		expect(mockNext).toHaveBeenCalled();
	});

	//   it('should block requests from blacklisted IPs', async () => {
	//     mockConfigService.get.mockReturnValue(['127.0.0.1']);
	//     await expect(middleware.use(mockRequest as Request, mockResponse as Response, mockNext))
	//       .rejects.toThrow('Access denied');
	//   });

	it('should allow requests from allowed regions', async () => {
		mockConfigService.get
			.mockReturnValueOnce([]) // blacklistedIPs
			.mockReturnValueOnce(['US']); // allowedRegions
		await middleware.use(
			mockRequest as Request,
			mockResponse as Response,
			mockNext
		);
		expect(mockNext).toHaveBeenCalled();
	});

	//   it('should block requests from disallowed regions', async () => {
	//     mockConfigService.get.mockReturnValueOnce([])  // blacklistedIPs
	//       .mockReturnValueOnce(['UK']);  // allowedRegions
	//     await expect(middleware.use(mockRequest as Request, mockResponse as Response, mockNext))
	//       .rejects.toThrow('Access denied from your region');
	//   });

	it('should apply global rate limiting', async () => {
		mockConfigService.get.mockReturnValue([]); // Empty blacklist and allowed regions
		(RateLimiterMemory.prototype.consume as jest.Mock).mockRejectedValue(
			new RateLimiterRes()
		);

		await expect(
			middleware.use(
				mockRequest as Request,
				mockResponse as Response,
				mockNext
			)
		).rejects.toThrow('Too Many Requests');
		expect(mockResponse.set).toHaveBeenCalledWith(
			'Retry-After',
			expect.any(String)
		);
	});

	//   it('should handle unexpected errors', async () => {
	//     mockConfigService.get.mockReturnValue([]); // Empty blacklist and allowed regions
	//     (RateLimiterMemory.prototype.consume as jest.Mock).mockRejectedValue(new Error('Unexpected error'));

	//     await expect(middleware.use(mockRequest as Request, mockResponse as Response, mockNext))
	//       .rejects.toThrow('Internal Server Error');
	//   });
});
