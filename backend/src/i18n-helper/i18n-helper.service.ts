import { Injectable } from '@nestjs/common';
import { I18nContext, I18nService } from 'nestjs-i18n';

@Injectable()
export class I18nHelperService {
	constructor(private readonly i18n: I18nService) {}

	t(key: string, options?: Record<string, any>): string {
		const lang = I18nContext.current()?.lang;
		return this.i18n.translate(key, { lang, args: options });
	}
}
