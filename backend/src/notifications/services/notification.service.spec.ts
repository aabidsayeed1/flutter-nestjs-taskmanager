import { Test, TestingModule } from '@nestjs/testing';
import { NotificationService } from './notification.service';
import { I18nService } from 'nestjs-i18n';
import { NotificationModeEnum } from '../enums/notification-mode.enum';
import { ProviderTypeEnum } from '../enums/provider-type.enum';
import { SendNotificationDto } from '../dto/send-notification.dto';

describe('NotificationService', () => {
	let service: NotificationService;

	const mockGupshupSmsProvider = {
		sendNotification: jest.fn()
	};

	const mockKaleyraSmsProvider = {
		sendNotification: jest.fn()
	};

	const mockNodemailerEmailProvider = {
		sendNotification: jest.fn()
	};

	const mockI18nService = {
		translate: jest.fn()
	};
	beforeEach(async () => {
		const module: TestingModule = await Test.createTestingModule({
			providers: [
				NotificationService,
				{
					provide: 'GupshupSmsProvider',
					useValue: mockGupshupSmsProvider
				},
				{
					provide: 'KaleyraSmsProvider',
					useValue: mockKaleyraSmsProvider
				},
				{
					provide: 'NodemailerEmailProvider',
					useValue: mockNodemailerEmailProvider
				},
				{ provide: I18nService, useValue: mockI18nService }
			]
		}).compile();

		service = module.get<NotificationService>(NotificationService);
	});

	it('should be defined', () => {
		expect(service).toBeDefined();
	});
	describe('sendNotification', () => {
		it('should send SMS using the specified provider', async () => {
			mockI18nService.translate.mockResolvedValue('Test message');

			const dto: SendNotificationDto = {
				mode: NotificationModeEnum.SMS,
				provider: ProviderTypeEnum.GUPSHUP,
				recipient: '1234567890',
				messageKey: 'testMessage',
				lang: 'en'
			};

			await service.sendNotification(dto);

			expect(
				mockGupshupSmsProvider.sendNotification
			).toHaveBeenCalledWith('1234567890', 'Test message', '');
		});

		it('should send Email using the specified provider with subject', async () => {
			mockI18nService.translate.mockImplementation((key: string) => {
				if (key === 'testMessage') return 'Test email message';
				if (key === 'testSubject') return 'Test email subject';
				return '';
			});

			const dto: SendNotificationDto = {
				mode: NotificationModeEnum.EMAIL,
				provider: ProviderTypeEnum.NODEMAILER,
				recipient: 'test@example.com',
				messageKey: 'testMessage',
				subjectKey: 'testSubject',
				lang: 'en'
			};

			await service.sendNotification(dto);

			expect(
				mockNodemailerEmailProvider.sendNotification
			).toHaveBeenCalledWith(
				'test@example.com',
				'Test email message',
				'Test email subject'
			);
		});

		it('should throw an error if the notification mode is unsupported', async () => {
			const unsupportedMode =
				'unsupportedMode' as unknown as NotificationModeEnum;
			const dto: SendNotificationDto = {
				mode: unsupportedMode,
				provider: ProviderTypeEnum.GUPSHUP,
				recipient: '1234567890',
				messageKey: 'testMessage',
				lang: 'en'
			};

			await expect(service.sendNotification(dto)).rejects.toThrow(
				`Unsupported notification mode ${dto.mode}`
			);
		});

		it('should throw an error if SMS provider is not supported', () => {
			const dto: SendNotificationDto = {
				mode: NotificationModeEnum.SMS,
				provider: ProviderTypeEnum.NODEMAILER,
				recipient: '1234567890',
				messageKey: 'testMessage',
				lang: 'en'
			};

			expect(() => service['getSmsProvider'](dto.provider)).toThrow(
				'SMS provider not supported'
			);
		});

		it('should throw an error if Email provider is not supported', () => {
			const dto: SendNotificationDto = {
				mode: NotificationModeEnum.EMAIL,
				provider: ProviderTypeEnum.GUPSHUP,
				recipient: 'test@example.com',
				messageKey: 'testMessage',
				subjectKey: 'testSubject',
				lang: 'en'
			};

			expect(() => service['getEmailProvider'](dto.provider)).toThrow(
				'Email provider not supported'
			);
		});
	});

	describe('send', () => {
		it('should throw an error if no notification modes are provided', async () => {
			await expect(service.send([], 'welcome', {})).rejects.toThrow(
				'At least one notification mode is required'
			);
		});

		it('should use "User" as the name if data.name is null', async () => {
			const data = { name: null, email: 'test@example.com' };
			const modes = [NotificationModeEnum.EMAIL];

			jest.spyOn(service, 'sendNotification');

			await service.send(modes, 'welcome', data);

			expect(service.sendNotification).toHaveBeenCalled();
			expect(data.name).toBe('User');
		});

		it('should send an email notification', async () => {
			const data = {
				name: 'Don',
				email: 'test@example.com',
				otp: '123456',
				expiry: '1'
			};
			const modes = [NotificationModeEnum.EMAIL];
			const expectedNotification = {
				mode: NotificationModeEnum.EMAIL,
				provider: ProviderTypeEnum.NODEMAILER,
				recipient: data.email,
				messageKey: 'notifications.customer-otp.email.message',
				subjectKey: 'notifications.customer-otp.email.subject',
				payload: data
			};
			const sendNotificationSpy = jest.spyOn(service, 'sendNotification');
			await service.send(modes, 'customer-otp', data);
			expect(sendNotificationSpy).toHaveBeenCalled();
			expect(sendNotificationSpy).toHaveBeenCalledWith(
				expect.objectContaining(expectedNotification)
			);
		});

		it('should send an SMS notification', async () => {
			const data = { name: 'Don', email: 'test@example.com' };
			const modes = [NotificationModeEnum.SMS];

			jest.spyOn(service, 'sendNotification');

			await service.send(modes, 'welcome', data);

			expect(service.sendNotification).toHaveBeenCalledWith(
				expect.objectContaining({
					mode: NotificationModeEnum.SMS,
					provider: ProviderTypeEnum.GUPSHUP,
					recipient: '91882501XXXX',
					messageKey: 'notifications.welcome.sms.message',
					payload: data
				})
			);
		});
	});
});
