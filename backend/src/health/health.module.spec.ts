import { Test, TestingModule } from '@nestjs/testing';
import { TerminusModule } from '@nestjs/terminus';
import { TypeOrmModule } from '@nestjs/typeorm';
import { HealthModule } from './health.module';
import { HealthService } from './health.service';
import { HealthController } from './health.controller';
import { RedisHealthIndicator } from './redis.health';
import { getRepositoryToken } from '@nestjs/typeorm';
import { Connection } from 'typeorm';

describe('HealthModule', () => {
	let module: TestingModule;

	beforeEach(async () => {
		module = await Test.createTestingModule({
			imports: [
				TerminusModule,
				TypeOrmModule.forRoot({
					type: 'sqlite',
					database: ':memory:',
					entities: [],
					synchronize: true
				}),
				HealthModule
			],
			providers: [
				{
					provide: getRepositoryToken(Connection),
					useValue: {}
				}
			]
		}).compile();
	});

	it('should be defined', () => {
		expect(module).toBeDefined();
	});

	it('should import TerminusModule', () => {
		expect(module.get(TerminusModule)).toBeDefined();
	});

	it('should import TypeOrmModule', () => {
		expect(module.get(TypeOrmModule)).toBeDefined();
	});

	it('should have HealthController', () => {
		expect(module.get(HealthController)).toBeDefined();
	});

	it('should have HealthService', () => {
		expect(module.get(HealthService)).toBeDefined();
	});

	it('should have RedisHealthIndicator', () => {
		expect(module.get(RedisHealthIndicator)).toBeDefined();
	});
});
