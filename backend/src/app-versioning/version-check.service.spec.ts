import { Test, TestingModule } from '@nestjs/testing';
import { VersionCheckService } from './version-check.service';

describe('VersionCheckService', () => {
	let service: VersionCheckService;

	beforeEach(async () => {
		const module: TestingModule = await Test.createTestingModule({
			providers: [VersionCheckService]
		}).compile();

		service = module.get<VersionCheckService>(VersionCheckService);
	});

	describe('verifyVersion', () => {
		it('should return no update required when versions match', () => {
			const config = {
				minVersionName: '1.0.0',
				latestVersionName: '1.0.0',
				featuresUpdate: {
					feature1: { path: 'path1', version: '1.0.0' }
				}
			};

			const result = service.verifyVersion('1.0.0', config);

			expect(result).toEqual({
				notifyUpdate: false,
				latestVersion: '1.0.0',
				forceUpdate: false,
				features: ['path1']
			});
		});

		it('should return force update when version matches minVersion but not latestVersion', () => {
			const config = {
				minVersionName: '1.0.0',
				latestVersionName: '1.1.0',
				featuresUpdate: {
					feature1: { path: 'path1', version: '1.1.0' }
				}
			};

			const result = service.verifyVersion('1.0.0', config);

			expect(result).toEqual({
				notifyUpdate: true,
				latestVersion: '1.1.0',
				forceUpdate: true,
				features: ['path1']
			});
		});

		it('should return notify update when a newer version is available', () => {
			const config = {
				minVersionName: '1.0.0',
				latestVersionName: '1.2.0',
				featuresUpdate: {
					feature1: { path: 'path1', version: '1.1.0' },
					feature2: { path: 'path2', version: '1.2.0' }
				}
			};

			const result = service.verifyVersion('1.1.0', config);

			expect(result).toEqual({
				notifyUpdate: true,
				latestVersion: '1.2.0',
				forceUpdate: false,
				features: ['path2']
			});
		});

		it('should return no update when current version is latest', () => {
			const config = {
				minVersionName: '1.0.0',
				latestVersionName: '1.2.0',
				featuresUpdate: {
					feature1: { path: 'path1', version: '1.1.0' },
					feature2: { path: 'path2', version: '1.2.0' }
				}
			};

			const result = service.verifyVersion('1.2.0', config);

			expect(result).toEqual({
				notifyUpdate: false,
				latestVersion: '1.2.0',
				forceUpdate: false,
				features: []
			});
		});
	});

	describe('updateAppVersion', () => {
		it('should return the result of verifyVersion when latestVersionOnServer exists', () => {
			const config = {
				minVersionName: '1.0.0',
				latestVersionName: '1.1.0',
				featuresUpdate: {
					feature1: { path: 'path1', version: '1.1.0' }
				}
			};

			const result = service.updateAppVersion('1.0.0', config);

			expect(result).toEqual({
				notifyUpdate: true,
				latestVersion: '1.1.0',
				forceUpdate: true,
				features: ['path1']
			});
		});

		it('should return no update when latestVersionOnServer does not exist', () => {
			const config = {
				minVersionName: '1.0.0',
				featuresUpdate: {}
			};

			const result = service.updateAppVersion('1.0.0', config);

			expect(result).toEqual({
				notifyUpdate: false,
				latestVersion: '1.0.0',
				forceUpdate: false,
				features: []
			});
		});

		it('should throw an error when an exception occurs', () => {
			const config = null; // This will cause an error

			expect(() => service.updateAppVersion('1.0.0', config)).toThrow();
		});
	});
});
