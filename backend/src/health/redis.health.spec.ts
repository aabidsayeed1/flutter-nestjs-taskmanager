import { Test, TestingModule } from '@nestjs/testing';
import { RedisHealthIndicator } from './redis.health';
import { HealthIndicatorResult, HealthCheckError } from '@nestjs/terminus';
import Redis from 'ioredis';

jest.mock('ioredis', () => {
	return {
		__esModule: true,
		default: jest.fn().mockImplementation(() => {
			return {
				ping: jest.fn(),
				quit: jest.fn()
			};
		})
	};
});

describe('RedisHealthIndicator', () => {
	let service: RedisHealthIndicator;
	let redisClient: Redis;

	beforeEach(async () => {
		const module: TestingModule = await Test.createTestingModule({
			providers: [RedisHealthIndicator]
		}).compile();

		service = module.get<RedisHealthIndicator>(RedisHealthIndicator);
		redisClient = service['client']; // Access the private Redis client for mocking

		jest.clearAllMocks();
	});

	it('should be defined', () => {
		expect(service).toBeDefined();
	});

	describe('onModuleInit', () => {
		it('should not need to explicitly connect Redis client', async () => {
			expect(service.onModuleInit).toBeDefined();
		});
	});

	describe('onModuleDestroy', () => {
		it('should quit Redis client', async () => {
			const quitSpy = jest
				.spyOn(redisClient, 'quit')
				.mockResolvedValue('OK');
			await service.onModuleDestroy();
			expect(quitSpy).toHaveBeenCalled();
		});
	});

	describe('isHealthy', () => {
		it('should return healthy status when Redis responds with PONG', async () => {
			jest.spyOn(redisClient, 'ping').mockResolvedValue('PONG');
			const result: HealthIndicatorResult =
				await service.isHealthy('redis');
			expect(result).toEqual({ redis: { status: 'up' } });
		});

		it('should throw HealthCheckError when Redis does not respond with PONG', async () => {
			jest.spyOn(redisClient, 'ping').mockRejectedValue(
				new Error('Connection error')
			);
			await expect(service.isHealthy('redis')).rejects.toThrow(
				HealthCheckError
			);
		});
	});
});
