import { Global, Module } from '@nestjs/common';
import { I18nHelperService } from './i18n-helper.service';

@Global()
@Module({
	providers: [I18nHelperService],
	exports: [I18nHelperService]
})
export class I18nHelperModule {}
