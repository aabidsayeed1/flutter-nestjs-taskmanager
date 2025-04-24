import { Injectable } from '@nestjs/common';
import { AppUpdateDto, SupportedOS } from './app-update.dto';
  @Injectable()
export class AppUpdateService {
  verifyVersion(appUpdateDto: AppUpdateDto):{
    notifyUpdate: boolean;
    latestVersion: string;
    forceUpdate: boolean;
    features: string[];
  } {
    // Retrieve environment variables for the given OS
    const minVersionOnServer =
    appUpdateDto.os === SupportedOS.Android
        ? process.env.APP_VERSIONS_MIN_ANDROID_VERSION_NAME
        : process.env.APP_VERSIONS_MIN_IOS_VERSION_NAME;

    const latestVersionOnServer =
    appUpdateDto.os === SupportedOS.Android
        ? process.env.APP_VERSIONS_LATEST_VERSION_OF_ANDROID
        : process.env.APP_VERSIONS_LATEST_VERSION_OF_IOS;

    // Parse feature configurations from environment variables
    const featuresConfig = JSON.parse(process.env.APP_VERSIONS_FEATURES || '{}') as FeaturesConfig;

    // If there's no latest version on the server, return a default response
    if (!latestVersionOnServer) {
      return {
        notifyUpdate: false,
        latestVersion: minVersionOnServer || 'Unknown',
        forceUpdate: false,
        features: [],
      };
    }

    // Ensure minVersionOnServer is defined
    if (!minVersionOnServer) {
      throw new Error('minVersionOnServer is not defined in the environment variables');
    }

    // Compare version numbers
    const [serverMajorVersion, serverMinorVersion, serverPatchVersion] =
      latestVersionOnServer.split('.').map(Number);
    const [majorVersion, minorVersion, patchVersion] = appUpdateDto.versionName
      .split('.')
      .map(Number);

    // Determine if an update is required
    const isUpdateRequired =
      serverMajorVersion > majorVersion ||
      (serverMajorVersion === majorVersion &&
        serverMinorVersion > minorVersion) ||
      (serverMajorVersion === majorVersion &&
        serverMinorVersion === minorVersion &&
        serverPatchVersion > patchVersion);

    if (isUpdateRequired) {
      // Split minVersionOnServer into components
      const [minMajorVersion, minMinorVersion, minPatchVersion] =
        minVersionOnServer.split('.').map(Number);

      // Determine if the update is forced based on the minimum version
      const isForcedUpdate =
        majorVersion < minMajorVersion ||
        (majorVersion === minMajorVersion && minorVersion < minMinorVersion) ||
        (majorVersion === minMajorVersion &&
          minorVersion === minMinorVersion &&
          patchVersion < minPatchVersion);

      // Determine which features require updates
      const features = Object.entries(featuresConfig)
        .filter(([_, featureInfo]) => {
          const [featureMajorVersion, featureMinorVersion, featurePatchVersion] =
            featureInfo.minVersion.split('.').map(Number);
          return (
            featureMajorVersion > majorVersion ||
            (featureMajorVersion === majorVersion &&
              featureMinorVersion > minorVersion) ||
            (featureMajorVersion === majorVersion &&
              featureMinorVersion === minorVersion &&
              featurePatchVersion > patchVersion)
          );
        })
        .map(([featureName]) => featureName);

      return {
        notifyUpdate: true,
        latestVersion: latestVersionOnServer,
        forceUpdate: isForcedUpdate,
        features,
      };
    }

    // Default response if no update is required
    return {
      notifyUpdate: false,
      latestVersion: latestVersionOnServer,
      forceUpdate: false,
      features: [],
    };
  }
}