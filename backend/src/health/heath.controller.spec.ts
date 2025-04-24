import { Test, TestingModule } from '@nestjs/testing';
import { HealthController } from './health.controller';
import { HealthService } from './health.service';
import {
	HealthCheckService,
	TypeOrmHealthIndicator,
	HealthCheckResult
} from '@nestjs/terminus';
import { RedisHealthIndicator } from './redis.health';

describe('HealthController', () => {
	let controller: HealthController;
	let healthService: HealthService;

	beforeEach(async () => {
		const module: TestingModule = await Test.createTestingModule({
			controllers: [HealthController],
			providers: [
				HealthService,
				{
					provide: HealthCheckService,
					useValue: {
						check: jest.fn().mockResolvedValue({
							status: 'ok',
							details: {}
						} as HealthCheckResult)
					}
				},
				{
					provide: TypeOrmHealthIndicator,
					useValue: {
						pingCheck: jest.fn().mockResolvedValue({
							status: 'up',
							details: {}
						} as unknown as HealthCheckResult)
					}
				},
				{
					provide: RedisHealthIndicator,
					useValue: {
						isHealthy: jest.fn().mockResolvedValue({
							status: 'up',
							details: {}
						} as unknown as HealthCheckResult)
					}
				}
			]
		}).compile();

		controller = module.get<HealthController>(HealthController);
		healthService = module.get<HealthService>(HealthService);
	});

	it('should be defined', () => {
		expect(controller).toBeDefined();
	});

	it('should check database health', async () => {
		const result: HealthCheckResult = { status: 'ok', details: {} };
		jest.spyOn(healthService, 'checkDatabase').mockResolvedValue(result);

		expect(await controller.checkDatabase()).toBe(result);
	});

	it('should check database migrations', async () => {
		const result: HealthCheckResult = { status: 'ok', details: {} };
		jest.spyOn(healthService, 'checkMigrations').mockResolvedValue(result);

		expect(await controller.checkMigrations()).toBe(result);
	});

	it('should check Redis health', async () => {
		const result: HealthCheckResult = { status: 'ok', details: {} };
		jest.spyOn(healthService, 'checkRedis').mockResolvedValue(result);

		expect(await controller.checkRedis()).toBe(result);
	});

	it('should check all services health', async () => {
		const result: HealthCheckResult = { status: 'ok', details: {} };
		jest.spyOn(healthService, 'checkAll').mockResolvedValue(result);

		expect(await controller.checkAll()).toBe(result);
	});

	it('should check general health', async () => {
		const result = {
			isHealthy: true,
			message: 'Successfully checked health api!'
		};
		jest.spyOn(healthService, 'checkGeneralHealth').mockResolvedValue(
			result
		);

		expect(await controller.checkGeneralHealth()).toBe(result);
	});
});
