import { Injectable, Logger } from '@nestjs/common';
import { ConfigService } from '@nestjs/config';
import FormData from 'form-data';
import Mailgun from 'mailgun.js';
import { INotificationProvider } from '../interfaces/notification-provider.interface';

@Injectable()
export class MailgunEmailProvider implements INotificationProvider {
	private readonly logger = new Logger(MailgunEmailProvider.name);
	constructor(private readonly config: ConfigService) {}

	private apiKey = process.env.MAILGUN_API_KEY!;
	private domain = process.env.MAILGUN_DOMAIN!;

	private client = new Mailgun(FormData).client({
		username: 'api',
		key: this.apiKey
	});

	async sendNotification(
		to: string,
		message: string,
		subject: string
	): Promise<void> {
		if (!this.apiKey || !this.domain) {
			throw new Error(
				'Mailgun API key or domain is not configured properly'
			);
		}

		const messageData = {
			from: `No Reply <${process.env.NO_REPLY_EMAIL}>`,
			to: [to],
			subject: subject,
			text: message
		};
		this.client.messages
			.create(this.domain, messageData)
			.then(res => {
				this.logger.log(
					`MailgunEmailProvider Response: ${JSON.stringify(res)}`
				);
			})
			.catch(err => {
				this.logger.error(`Failed to send Mail to ${to}`, err.stack);
			});
	}
}
