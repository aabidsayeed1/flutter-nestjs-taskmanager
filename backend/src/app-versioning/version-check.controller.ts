import {
	Controller,
	Post,
	Body,
	HttpException,
	HttpStatus
} from '@nestjs/common';
import { ConfigService } from '@nestjs/config';
import { VersionCheckService } from './version-check.service';

@Controller('web')
export class VersionCheckController {
	constructor(
		private readonly versionCheckService: VersionCheckService,
		private readonly configService: ConfigService
	) {}

	@Post('app-version')
	async getAppVersion(@Body() body: any) {
		try {
			const { versionName } = body;
			const config = this.configService.get('webAppVersions');

			console.log('Received versionName:', versionName);
			console.log('Loaded configuration:', config);

			const response = await this.versionCheckService.updateAppVersion(
				versionName,
				config
			);

			return {
				success: true,
				message: 'Successfully got app version!',
				data: response
			};
		} catch (error) {
			console.error('Error occurred:', error);
			throw new HttpException(
				'Internal server error',
				HttpStatus.INTERNAL_SERVER_ERROR
			);
		}
	}
}
