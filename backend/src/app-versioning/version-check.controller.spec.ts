import { HttpException, HttpStatus } from '@nestjs/common';
import { ConfigService } from '@nestjs/config';
import { Test, TestingModule } from '@nestjs/testing';
import { VersionCheckService } from '../app-versioning/version-check.service';
import { VersionCheckController } from './version-check.controller';

describe('VersionCheckController', () => {
	let versionCheckController: VersionCheckController;
	let versionCheckService: VersionCheckService;
	let configService: ConfigService;

	beforeEach(async () => {
		const module: TestingModule = await Test.createTestingModule({
			controllers: [VersionCheckController],
			providers: [
				VersionCheckService,
				{
					provide: ConfigService,
					useValue: {
						get: jest.fn()
					}
				}
			]
		}).compile();

		versionCheckController = module.get<VersionCheckController>(
			VersionCheckController
		);
		versionCheckService =
			module.get<VersionCheckService>(VersionCheckService);
		configService = module.get<ConfigService>(ConfigService);
	});

	it('should be defined', () => {
		expect(versionCheckController).toBeDefined();
	});

	describe('getAppVersion', () => {
		it('should return app version successfully', async () => {
			const body = { versionName: '1.0.0' };
			const config = { someKey: 'someValue' };
			const serviceResponse = { version: '1.0.0', status: 'up-to-date' };

			jest.spyOn(configService, 'get').mockReturnValue(config);
			jest.spyOn(
				versionCheckService,
				'updateAppVersion'
			).mockResolvedValue(serviceResponse);

			const result = await versionCheckController.getAppVersion(body);

			expect(result).toEqual({
				success: true,
				message: 'Successfully got app version!',
				data: serviceResponse
			});
			expect(configService.get).toHaveBeenCalledWith('webAppVersions');
			expect(versionCheckService.updateAppVersion).toHaveBeenCalledWith(
				body.versionName,
				config
			);
		});

		it('should throw an HttpException when an error occurs', async () => {
			const body = { versionName: '1.0.0' };
			const errorMessage = 'Internal server error';

			jest.spyOn(configService, 'get').mockReturnValue(null);
			jest.spyOn(
				versionCheckService,
				'updateAppVersion'
			).mockImplementation(() => {
				throw new Error(errorMessage);
			});

			await expect(
				versionCheckController.getAppVersion(body)
			).rejects.toThrow(
				new HttpException(
					errorMessage,
					HttpStatus.INTERNAL_SERVER_ERROR
				)
			);
		});
	});
});
