import { ConfigService } from '@nestjs/config';
import { Test, TestingModule } from '@nestjs/testing';
import configuration from '../config/config';
import { VersionCheckController } from './version-check.controller';
import { VersionCheckModule } from './version-check.module';
import { VersionCheckService } from './version-check.service';

describe('VersionCheckModule', () => {
	let module: TestingModule;

	beforeEach(async () => {
		module = await Test.createTestingModule({
			imports: [VersionCheckModule]
		}).compile();
	});

	it('should be defined', () => {
		expect(module).toBeDefined();
	});

	it('should load configuration', () => {
		const configService = module.get<ConfigService>(ConfigService);
		expect(configService).toBeDefined();
		expect(configService.get('webAppVersions')).toEqual(
			configuration().webAppVersions
		);
	});

	it('should have VersionCheckService', () => {
		const service = module.get<VersionCheckService>(VersionCheckService);
		expect(service).toBeDefined();
	});

	it('should have VersionCheckController', () => {
		const controller = module.get<VersionCheckController>(
			VersionCheckController
		);
		expect(controller).toBeDefined();
	});
});
