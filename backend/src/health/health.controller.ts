import { Controller, Get } from '@nestjs/common';
import { HealthService } from './health.service';

@Controller('healtz')
export class HealthController {
	constructor(private readonly healthService: HealthService) {}

	@Get('/db')
	checkDatabase() {
		return this.healthService.checkDatabase();
	}

	@Get('/db/migration')
	checkMigrations() {
		return this.healthService.checkMigrations();
	}

	@Get('/redis')
	checkRedis() {
		return this.healthService.checkRedis();
	}

	@Get('/all')
	checkAll() {
		return this.healthService.checkAll();
	}

	@Get()
	checkGeneralHealth() {
		return this.healthService.checkGeneralHealth();
	}
}
