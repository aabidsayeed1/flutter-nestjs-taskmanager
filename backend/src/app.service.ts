import { Injectable } from '@nestjs/common';
import { I18nHelperService } from './i18n-helper/i18n-helper.service';

@Injectable()
export class AppService {
	constructor(private i18nHelperService: I18nHelperService) {}

	getHello(): string {
		return this.i18nHelperService.t('messages.HELLO_WORLD');
	}
}
