import { INotificationProvider } from '@/notifications/interfaces/notification-provider.interface';
import { Injectable, Logger } from '@nestjs/common';
import axios, { AxiosRequestConfig } from 'axios';

@Injectable()
export class KaleyraSmsProvider implements INotificationProvider {
	private readonly logger = new Logger(KaleyraSmsProvider.name);
	private readonly baseUrl = `https://api.kaleyra.io/v1/${process.env.KALEYRA_SENDER_ID}/messages`;

	async sendNotification(to: string, message: string): Promise<void> {
		const params = {
			sender: 'MVPRockets',
			to: to,
			body: message,
			type: 'OTP'
		};
		const config: AxiosRequestConfig = {
			headers: {
				'api-key': process.env.KALEYRA_API_KEY,
				'Content-Type': 'application/x-www-form-urlencoded'
			}
		};
		await axios
			.post(this.baseUrl, params, config)
			.then(res => {
				this.logger.log(`SMS sent to ${to}: ${message}`);
				this.logger.debug(
					`Kaleyra Response: ${JSON.stringify(res.data)}`
				);
			})
			.catch(error => {
				this.logger.error(`Failed to send SMS to ${to}`, error.stack);
				throw new Error(`Kaleyra SMS send failed: ${error.message}`);
			});
	}
}
