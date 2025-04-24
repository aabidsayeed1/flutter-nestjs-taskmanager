import { Injectable, OnModuleDestroy, OnModuleInit } from '@nestjs/common';
import {
	HealthCheckError,
	HealthIndicator,
	HealthIndicatorResult
} from '@nestjs/terminus';
import * as dotenv from 'dotenv';
import Redis from 'ioredis';
dotenv.config({
	path: `${__dirname}/../../envs/.env.${process.env.NODE_ENV || 'dev'}`
});

@Injectable()
export class RedisHealthIndicator
	extends HealthIndicator
	implements OnModuleInit, OnModuleDestroy
{
	private client: Redis;

	constructor() {
		super();
		this.client = new Redis({
			host: `${process.env.REDIS_HOST}`,
			port: +`${process.env.REDIS_PORT}`
			// password: '', // Uncomment and set the password if Redis is password protected
		});
	}

	async onModuleInit() {
		// Redis client already connects automatically, no need for an explicit connect call
	}

	async onModuleDestroy() {
		await this.client.quit();
	}

	async isHealthy(key: string): Promise<HealthIndicatorResult> {
		try {
			const ping = await this.client.ping();
			const isHealthy = ping === 'PONG';
			return this.getStatus(key, isHealthy);
		} catch (err) {
			throw new HealthCheckError('Redis health check failed', err);
		}
	}
}
