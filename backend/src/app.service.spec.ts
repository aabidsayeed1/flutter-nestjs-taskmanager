import { Test, TestingModule } from '@nestjs/testing';
import { AppService } from './app.service';
import { I18nHelperService } from './i18n-helper/i18n-helper.service';
import { mockI18nHelperService } from './utils/test-utils';

describe('AppService', () => {
	let appService: AppService;

	beforeEach(async () => {
		const module: TestingModule = await Test.createTestingModule({
			providers: [
				AppService,
				{
					provide: I18nHelperService,
					useValue: mockI18nHelperService
				}
			]
		}).compile();

		appService = module.get<AppService>(AppService);
	});

	describe('getHello', () => {
		it('should return "Hello World!"', () => {
			expect(appService.getHello()).toBe('Hello World!');
		});
	});
});
