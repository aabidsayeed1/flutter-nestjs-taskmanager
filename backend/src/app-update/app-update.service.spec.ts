import { Test } from '@nestjs/testing';
import { AppUpdateService } from './app-update.service';
import { AppUpdateDto } from './app-update.dto';

describe('AppUpdateService', () => {
  let appUpdateService: AppUpdateService;

  beforeEach(async () => {
    process.env.APP_VERSIONS_MIN_ANDROID_VERSION_NAME = '2.0.0';
    process.env.APP_VERSIONS_LATEST_VERSION_OF_ANDROID = '2.3.0';
    process.env.APP_VERSIONS_FEATURES = JSON.stringify({
      profile: { minVersion: '2.2.0' },
      videoContent: { minVersion: '2.3.0' },
    });

    const moduleRef = await Test.createTestingModule({
      providers: [AppUpdateService],
    }).compile();

    appUpdateService = moduleRef.get<AppUpdateService>(AppUpdateService);
  });

  describe('verifyVersion', () => {
    it('should return no update for version 2.3.0 (latest version)', () => {
      const result = appUpdateService.verifyVersion({ versionName: '2.3.0', os: 'android' } as AppUpdateDto);
      expect(result).toEqual({
        notifyUpdate: false,
        latestVersion: '2.3.0',
        forceUpdate: false,
        features: [],
      });
    });

    it('should return forced update for version 1.9.0 (below minVersion)', () => {
      const result = appUpdateService.verifyVersion({ versionName: '1.9.0', os: 'android' } as AppUpdateDto);
      expect(result).toEqual({
        notifyUpdate: true,
        latestVersion: '2.3.0',
        forceUpdate: true,
        features: ['profile', 'videoContent'],
      });
    });

    it('should return optional update with profile and videoContent feature for version 2.0.0', () => {
      const result = appUpdateService.verifyVersion({ versionName: '2.0.0', os: 'android' } as AppUpdateDto);
      expect(result).toEqual({
        notifyUpdate: true,
        latestVersion: '2.3.0',
        forceUpdate: false,
        features: ['profile','videoContent'],
      });
    });

    it('should return optional update with profile and videoContent features for version 2.1.0', () => {
      const result = appUpdateService.verifyVersion({ versionName: '2.1.0', os: 'android' } as AppUpdateDto);
      expect(result).toEqual({
        notifyUpdate: true,
        latestVersion: '2.3.0',
        forceUpdate: false,
        features: ['profile', 'videoContent'],
      });
    });

    it('should return optional update with videoContent feature for version 2.2.0', () => {
      const result = appUpdateService.verifyVersion({ versionName: '2.2.0', os: 'android' } as AppUpdateDto);
      expect(result).toEqual({
        notifyUpdate: true,
        latestVersion: '2.3.0',
        forceUpdate: false,
        features: ['videoContent'],
      });
    });

    it('should handle missing environment variables gracefully', () => {
      delete process.env.APP_VERSIONS_MIN_ANDROID_VERSION_NAME;
      delete process.env.APP_VERSIONS_LATEST_VERSION_OF_ANDROID;
      delete process.env.APP_VERSIONS_FEATURES;

      const result = appUpdateService.verifyVersion({ versionName: '1.9.0', os: 'android' } as AppUpdateDto);
      expect(result).toEqual({
        notifyUpdate: false,
        latestVersion: 'Unknown',
        forceUpdate: false,
        features: [],
      });
    });
  });
});