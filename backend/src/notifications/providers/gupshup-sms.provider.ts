import { INotificationProvider } from '@/notifications/interfaces/notification-provider.interface';
import { Injectable, Logger } from '@nestjs/common';
import axios, { AxiosRequestConfig } from 'axios';
@Injectable()
export class GupshupSmsProvider implements INotificationProvider {
	private readonly logger = new Logger(GupshupSmsProvider.name);
	private readonly baseUrl =
		'http://enterprise.smsgupshup.com/GatewayAPI/rest';

	async sendNotification(to: string, message: string): Promise<void> {
		const params = new URLSearchParams();
		params.append('userid', process.env.GUPSHUP_USER_ID as string);
		params.append('password', process.env.GUPSHUP_PASSWORD as string);
		params.append('send_to', to);
		params.append('msg', message);
		params.append('method', 'sendMessage');
		params.append('msg_type', 'TEXT');
		params.append('format', 'text');
		params.append('auth_scheme', 'plain');
		params.append('v', '1.1');

		const config: AxiosRequestConfig = {
			headers: {
				'Content-Type': 'application/x-www-form-urlencoded'
			}
		};
		await axios
			.post(this.baseUrl, params, config)
			.then(res => {
				this.logger.log(`SMS sent to ${to}: ${message}`);
				this.logger.debug(
					`Gupshup Response: ${JSON.stringify(res.data)}`
				);
				console.log(`Gupshup Response: ${JSON.stringify(res.data)}`);
				if (res.data.includes('error')) {
					throw new Error(JSON.stringify(res.data));
				}
			})
			.catch(error => {
				this.logger.error(`Failed to send SMS to ${to}`, error.stack);
				throw new Error(`Gupshup SMS send failed: ${error.message}`);
			});
	}
}
