import { Module } from '@nestjs/common';
import { TerminusModule } from '@nestjs/terminus';
import { TypeOrmModule } from '@nestjs/typeorm';
import { HealthService } from './health.service';
import { HealthController } from './health.controller';
import { RedisHealthIndicator } from './redis.health';

@Module({
	imports: [TerminusModule, TypeOrmModule],
	controllers: [HealthController],
	providers: [HealthService, RedisHealthIndicator]
})
export class HealthModule {}
