import { Controller, Get, InternalServerErrorException } from '@nestjs/common';
import { AppService } from './app.service';
import { I18nHelperService } from './i18n-helper/i18n-helper.service';

@Controller()
export class AppController {
	constructor(
		private readonly appService: AppService,
		private i18nHelperService: I18nHelperService
	) {}

	@Get('/')
	getHello(): string {
		return this.appService.getHello();
	}

	@Get('error')
	throwError() {
		throw new InternalServerErrorException(
			this.i18nHelperService.t('errors.TEST_ERROR')
		);
	}
}
