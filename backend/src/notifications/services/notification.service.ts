import { Inject, Injectable } from '@nestjs/common';
import { I18nService } from 'nestjs-i18n';
import { SendNotificationDto } from '../dto/send-notification.dto';
import { NotificationModeEnum } from '../enums/notification-mode.enum';
import { ProviderTypeEnum } from '../enums/provider-type.enum';
import { INotificationProvider } from '../interfaces/notification-provider.interface';

@Injectable()
export class NotificationService {
	constructor(
		@Inject('GupshupSmsProvider')
		private gupshupSmsProvider: INotificationProvider,
		@Inject('KaleyraSmsProvider')
		private kaleyraSmsProvider: INotificationProvider,
		@Inject('NodemailerEmailProvider')
		private nodemailerEmailProvider: INotificationProvider,
		private i18n: I18nService
	) {}

	async sendNotification({
		mode,
		provider,
		recipient,
		messageKey,
		subjectKey,
		lang = 'en',
		payload = {}
	}: SendNotificationDto) {
		const message = (await this.i18n.translate(messageKey, {
			lang,
			args: payload
		})) as string;

		let subject = '';
		if (mode === NotificationModeEnum.EMAIL && subjectKey) {
			subject = (await this.i18n.translate(subjectKey, {
				lang,
				args: payload
			})) as string;
		}
		let selectedProvider: INotificationProvider | undefined;
		if (mode === NotificationModeEnum.SMS) {
			selectedProvider = this.getSmsProvider(provider);
		} else if (mode === NotificationModeEnum.EMAIL) {
			selectedProvider = this.getEmailProvider(provider);
		}

		if (selectedProvider) {
			await selectedProvider.sendNotification(
				recipient,
				message,
				subject
			);
		} else {
			throw new Error(`Unsupported notification mode ${mode}`);
		}
	}

	private getSmsProvider(provider: ProviderTypeEnum): INotificationProvider {
		switch (provider) {
			case ProviderTypeEnum.GUPSHUP:
				return this.gupshupSmsProvider;
			case ProviderTypeEnum.KALEYRA:
				return this.kaleyraSmsProvider;
			default:
				throw new Error('SMS provider not supported');
		}
	}

	private getEmailProvider(
		provider: ProviderTypeEnum
	): INotificationProvider {
		switch (provider) {
			case ProviderTypeEnum.NODEMAILER:
				return this.nodemailerEmailProvider;
			default:
				throw new Error('Email provider not supported');
		}
	}

	async send(modes: NotificationModeEnum[], context: string, data: any) {
		let sendNotification: SendNotificationDto;
		if (modes.length === 0) {
			throw new Error('At least one notification mode is required');
		}
		if (!data.name) {
			data.name = 'User';
		}
		const key = `notifications.${context}.`;
		modes.map(async mode => {
			if (mode === NotificationModeEnum.EMAIL) {
				sendNotification = {
					mode: NotificationModeEnum.EMAIL,
					provider: ProviderTypeEnum.NODEMAILER,
					recipient: data.email,
					messageKey: key + 'email.message',
					subjectKey: key + 'email.subject',
					payload: data
				};
			} else if (mode === NotificationModeEnum.SMS) {
				sendNotification = {
					mode: NotificationModeEnum.SMS,
					provider: ProviderTypeEnum.GUPSHUP,
					recipient: '91882501XXXX', //user phone number
					messageKey: key + 'sms.message',
					payload: data
				};
			} else if (mode === NotificationModeEnum.WHATSAPP) {
				sendNotification = {
					mode: NotificationModeEnum.WHATSAPP,
					provider: ProviderTypeEnum.KALEYRA,
					recipient: '91882501XXXX', //user phone number
					messageKey: key + 'whatsapp.message',
					payload: data
				};
			} else {
				throw new Error('invalid notification mode');
			}
			await this.sendNotification(sendNotification!);
		});
	}
}
