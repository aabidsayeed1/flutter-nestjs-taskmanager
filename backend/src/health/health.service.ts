import { Injectable } from '@nestjs/common';
import {
	HealthCheckService,
	TypeOrmHealthIndicator,
	HealthIndicatorResult,
	HealthCheckResult
} from '@nestjs/terminus';
import { RedisHealthIndicator } from './redis.health';
import { dataSource } from '../database/data-source';

@Injectable()
export class HealthService {
	constructor(
		private health: HealthCheckService,
		private db: TypeOrmHealthIndicator,
		private redis: RedisHealthIndicator
	) {}

	checkDatabase(): Promise<HealthCheckResult> {
		return this.health.check([async () => this.db.pingCheck('database')]);
	}

	async checkMigrations(): Promise<HealthCheckResult> {
		return this.health.check([
			async () => {
				if (!dataSource.isInitialized) {
					await dataSource.initialize();
				}

				const hasPendingMigrations = await dataSource.showMigrations();
				const isHealthy = !hasPendingMigrations;

				const pendingMigrations = hasPendingMigrations
					? await dataSource.runMigrations({ transaction: 'none' })
					: [];

				const result: HealthIndicatorResult = {
					migration: {
						status: isHealthy ? 'up' : 'down',
						pendingMigrations: pendingMigrations.map(
							migration => migration.name
						)
					}
				};

				return result;
			}
		]);
	}

	checkRedis(): Promise<HealthCheckResult> {
		return this.health.check([() => this.redis.isHealthy('redis')]);
	}

	checkAll(): Promise<HealthCheckResult> {
		return this.health.check([
			async () => this.db.pingCheck('database'),
			() => this.redis.isHealthy('redis'),
			async () => {
				const isHealthy = true;
				const result: HealthIndicatorResult = {
					migration: {
						status: isHealthy ? 'up' : 'down'
					}
				};
				return result;
			}
		]);
	}

	async checkGeneralHealth(): Promise<{
		isHealthy: boolean;
		message: string;
	}> {
		return {
			isHealthy: true,
			message: 'Successfully checked health api!'
		};
	}
}
