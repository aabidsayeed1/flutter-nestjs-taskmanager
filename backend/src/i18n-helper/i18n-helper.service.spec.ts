import { Test, TestingModule } from '@nestjs/testing';
import { I18nContext, I18nService } from 'nestjs-i18n';
import { I18nHelperService } from './i18n-helper.service';

describe('I18nHelperService', () => {
	let i18nHelperService: I18nHelperService;
	let i18nService: I18nService;

	beforeEach(async () => {
		const module: TestingModule = await Test.createTestingModule({
			providers: [
				I18nHelperService,
				{
					provide: I18nService,
					useValue: {
						translate: jest
							.fn()
							.mockImplementation((key, options) => {
								// Mock translation logic
								return `${key} - ${options?.lang}`;
							})
					}
				}
			]
		}).compile();

		i18nHelperService = module.get<I18nHelperService>(I18nHelperService);
		i18nService = module.get<I18nService>(I18nService);
	});

	it('should be defined', () => {
		expect(i18nHelperService).toBeDefined();
	});

	it('should translate a key with the provided language', () => {
		const result = i18nHelperService.t('USER_NOT_FOUND', { id: 123 });
		expect(result).toBe('USER_NOT_FOUND - undefined');
		expect(i18nService.translate).toHaveBeenCalledWith('USER_NOT_FOUND', {
			lang: undefined,
			args: { id: 123 }
		});
	});

	it('should translate with a specified language', () => {
		jest.spyOn(I18nContext, 'current').mockReturnValue({
			lang: 'es'
		} as any);
		const result = i18nHelperService.t('USER_NOT_FOUND', { id: 456 });
		expect(result).toBe('USER_NOT_FOUND - es');
		expect(i18nService.translate).toHaveBeenCalledWith('USER_NOT_FOUND', {
			lang: 'es',
			args: { id: 456 }
		});
	});
});
