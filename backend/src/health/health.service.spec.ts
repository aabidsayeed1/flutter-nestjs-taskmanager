import { Test, TestingModule } from '@nestjs/testing';
import {
	HealthCheckService,
	TypeOrmHealthIndicator,
	HealthCheckResult,
	HealthIndicatorResult
} from '@nestjs/terminus';
import { HealthService } from './health.service';
import { RedisHealthIndicator } from './redis.health';
import { dataSource } from '../database/data-source';
import { Migration } from 'typeorm';
import { HealthCheckExecutor } from '@nestjs/terminus/dist/health-check/health-check-executor.service';

jest.mock('../database/data-source', () => ({
	dataSource: {
		isInitialized: false,
		initialize: jest.fn(),
		showMigrations: jest.fn(),
		runMigrations: jest.fn()
	}
}));

describe('HealthService', () => {
	let healthService: HealthService;
	let healthCheckService: HealthCheckService;
	let typeOrmHealthIndicator: TypeOrmHealthIndicator;
	let redisHealthIndicator: RedisHealthIndicator;

	beforeEach(async () => {
		const module: TestingModule = await Test.createTestingModule({
			providers: [
				HealthService,
				HealthCheckService,
				HealthCheckExecutor,
				{
					provide: TypeOrmHealthIndicator,
					useValue: {
						pingCheck: jest.fn()
					}
				},
				{
					provide: RedisHealthIndicator,
					useValue: { isHealthy: jest.fn() }
				},
				{
					provide: 'TERMINUS_LOGGER',
					useValue: {
						log: jest.fn(),
						error: jest.fn(),
						warn: jest.fn()
					}
				},
				{
					provide: 'TERMINUS_ERROR_LOGGER',
					useValue: {
						log: jest.fn(),
						error: jest.fn(),
						warn: jest.fn()
					}
				}
			]
		}).compile();

		healthService = module.get<HealthService>(HealthService);
		healthCheckService = module.get<HealthCheckService>(HealthCheckService);
		typeOrmHealthIndicator = module.get<TypeOrmHealthIndicator>(
			TypeOrmHealthIndicator
		);
		redisHealthIndicator =
			module.get<RedisHealthIndicator>(RedisHealthIndicator);
	});

	it('should be defined', () => {
		expect(healthService).toBeDefined();
	});

	describe('checkDatabase', () => {
		it('should check database health', async () => {
			const result: HealthCheckResult = {
				status: 'ok',
				info: {
					database: { status: 'up' }
				},
				error: {},
				details: {
					database: { status: 'up' }
				}
			};
			jest.spyOn(healthCheckService, 'check').mockImplementation(
				async () => result
			);

			expect(await healthService.checkDatabase()).toBe(result);
		});
	});

	describe('checkMigrations', () => {
		it('should check migration health and find no pending migrations', async () => {
			jest.spyOn(dataSource, 'initialize').mockResolvedValue(dataSource);
			(dataSource as any).isInitialized = true;
			jest.spyOn(dataSource, 'showMigrations').mockResolvedValue(false);

			const result: HealthCheckResult = {
				status: 'ok',
				info: {
					migration: {
						status: 'up',
						pendingMigrations: []
					}
				},
				error: {},
				details: {
					migration: {
						status: 'up',
						pendingMigrations: []
					}
				}
			};

			expect(await healthService.checkMigrations()).toEqual(result);
		});

		it('should check migration health and find pending migrations', async () => {
			const pendingMigrations: Migration[] = [
				{
					id: 1,
					timestamp: Date.now(),
					name: 'TestMigration',
					instance: {} as any
				}
			];
			jest.spyOn(dataSource, 'initialize').mockResolvedValue(dataSource);
			(dataSource as any).isInitialized = true;
			jest.spyOn(dataSource, 'showMigrations').mockResolvedValue(true);
			jest.spyOn(dataSource, 'runMigrations').mockResolvedValue(
				pendingMigrations
			);

			const result: HealthCheckResult = {
				status: 'ok',
				info: {
					migration: {
						status: 'down',
						pendingMigrations: ['TestMigration']
					}
				},
				error: {},
				details: {
					migration: {
						status: 'down',
						pendingMigrations: ['TestMigration']
					}
				}
			};

			expect(await healthService.checkMigrations()).toEqual(result);
		});
	});

	describe('checkRedis', () => {
		it('should check Redis health', async () => {
			const result: HealthIndicatorResult = {
				redis: { status: 'up' }
			};
			jest.spyOn(redisHealthIndicator, 'isHealthy').mockResolvedValue(
				result
			);
			jest.spyOn(healthCheckService, 'check').mockImplementation(
				async () => ({
					status: 'ok',
					info: result,
					error: {},
					details: result
				})
			);

			expect(await healthService.checkRedis()).toEqual({
				status: 'ok',
				info: result,
				error: {},
				details: result
			});
		});
	});

	describe('checkAll', () => {
		it('should check all health indicators', async () => {
			const dbResult: HealthIndicatorResult = {
				database: { status: 'up' }
			};
			const redisResult: HealthIndicatorResult = {
				redis: { status: 'up' }
			};
			const migrationResult: HealthIndicatorResult = {
				migration: { status: 'up' }
			};

			const result: HealthCheckResult = {
				status: 'ok',
				info: {
					database: dbResult.database,
					redis: redisResult.redis,
					migration: migrationResult.migration
				},
				error: {},
				details: {
					database: dbResult.database,
					redis: redisResult.redis,
					migration: migrationResult.migration
				}
			};

			jest.spyOn(healthCheckService, 'check').mockImplementation(
				async indicators => {
					const checks = await Promise.all(
						indicators.map(indicator => indicator())
					);
					return checks.reduce(
						(acc, check) => ({
							...acc,
							info: { ...acc.info, ...check },
							details: { ...acc.details, ...check }
						}),
						{ status: 'ok', info: {}, error: {}, details: {} }
					);
				}
			);
			jest.spyOn(typeOrmHealthIndicator, 'pingCheck').mockResolvedValue(
				dbResult
			);
			jest.spyOn(redisHealthIndicator, 'isHealthy').mockResolvedValue(
				redisResult
			);

			expect(await healthService.checkAll()).toEqual(result);
		});
	});

	describe('checkGeneralHealth', () => {
		it('should return general health status', async () => {
			const result = {
				isHealthy: true,
				message: 'Successfully checked health api!'
			};

			expect(await healthService.checkGeneralHealth()).toEqual(result);
		});
	});
});
