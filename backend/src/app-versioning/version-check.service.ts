import { Injectable } from '@nestjs/common';

@Injectable()
export class VersionCheckService {
	verifyVersion(versionName: string, config: any): any {
		// eslint-disable-next-line @typescript-eslint/no-unused-vars
		const versionKey = 'webAppVersions';
		const minVersionOnServer = config.minVersionName;
		const latestVersionOnServer = config.latestVersionName;

		if (versionName === minVersionOnServer && latestVersionOnServer) {
			if (versionName === latestVersionOnServer) {
				return {
					notifyUpdate: false,
					latestVersion: latestVersionOnServer,
					forceUpdate: false,
					features: Object.values(config?.featuresUpdate || {}).map(
						(featureInfo: any) => featureInfo.path
					)
				};
			}
			return {
				notifyUpdate: true,
				latestVersion: latestVersionOnServer,
				forceUpdate: true,
				features: Object.values(config?.featuresUpdate || {}).map(
					(featureInfo: any) => featureInfo.path
				)
			};
		}

		if (latestVersionOnServer) {
			const [serverMajorVersion, serverMinorVersion, serverPatchVersion] =
				latestVersionOnServer
					.split('.')
					.map((val: string) => Number(val));
			const [majorVersion, minorVersion, patchVersion] = versionName
				.split('.')
				.map((val: string) => Number(val));

			if (
				serverMajorVersion > majorVersion ||
				(serverMajorVersion === majorVersion &&
					serverMinorVersion > minorVersion) ||
				(serverMajorVersion === majorVersion &&
					serverMinorVersion === minorVersion &&
					serverPatchVersion > patchVersion)
			) {
				const featureVersions = Object.entries(
					config?.featuresUpdate ?? {}
				)
					// eslint-disable-next-line @typescript-eslint/no-unused-vars
					.filter(([feature, featureInfo]: any) => {
						const [
							featureMajorVersion,
							featureMinorVersion,
							featurePatchVersion
						] = featureInfo.version
							.split('.')
							.map((val: string) => Number(val));
						return (
							featureMajorVersion > majorVersion ||
							(featureMajorVersion === majorVersion &&
								featureMinorVersion > minorVersion) ||
							(featureMajorVersion === majorVersion &&
								featureMinorVersion === minorVersion &&
								featurePatchVersion > patchVersion)
						);
					})
					// eslint-disable-next-line @typescript-eslint/no-unused-vars
					.map(([feature, featureInfo]: any) => featureInfo.path);

				return {
					notifyUpdate: true,
					latestVersion: latestVersionOnServer,
					forceUpdate: false,
					features: featureVersions
				};
			}
		}

		return {
			notifyUpdate: false,
			latestVersion: latestVersionOnServer,
			forceUpdate: false,
			features: []
		};
	}

	updateAppVersion(versionName: string, config: any): any {
		try {
			// eslint-disable-next-line @typescript-eslint/no-unused-vars
			const versionKey = 'webAppVersions';
			const latestVersionOnServer = config.latestVersionName;
			const minVersionOnServer = config.minVersionName;

			if (latestVersionOnServer) {
				const result = this.verifyVersion(versionName, config);
				return result;
			} else {
				return {
					notifyUpdate: false,
					latestVersion: latestVersionOnServer
						? latestVersionOnServer
						: minVersionOnServer,
					forceUpdate: false,
					features: []
				};
			}
		} catch (error) {
			console.error('Error in updateAppVersion:', error);
			throw error;
		}
	}
}
