export interface MockMigration {
	id: number;
	name: string;
	timestamp: number;
	instance: any;
}
import errors from '../i18n/en/errors.json';
import messages from '../i18n/en/messages.json';

export const mockI18nHelperService = {
	t: jest.fn((key: string, values?: Record<string, string | number>) => {
		let translation = mockTranslations[key] || key;

		if (values) {
			Object.entries(values).forEach(([placeholder, value]) => {
				translation = translation.replace(
					new RegExp(`{${placeholder}}`, 'g'),
					String(value)
				);
			});
		}

		return translation;
	})
};
export const mockTranslations: any = {
	...Object.entries(errors).reduce(
		(acc, [key, value]) => ({ ...acc, [`errors.${key}`]: value }),
		{}
	),
	...Object.entries(messages).reduce(
		(acc, [key, value]) => ({ ...acc, [`messages.${key}`]: value }),
		{}
	)
};
