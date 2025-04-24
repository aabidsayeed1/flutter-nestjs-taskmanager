import * as nodemailer from 'nodemailer';
import { INotificationProvider } from '../interfaces/notification-provider.interface';
import { Injectable } from '@nestjs/common';

@Injectable()
export class NodemailerEmailProvider implements INotificationProvider {
	private transporter = nodemailer?.createTransport({
		host: process.env.EMAIL_HOST,
		port: parseInt(process.env.EMAIL_PORT!, 10),
		secure: false,
		auth: {
			user: process.env.EMAIL_USER,
			pass: process.env.EMAIL_PASS
		}
	});

	async sendNotification(
		to: string,
		message: string,
		subject: string
	): Promise<void> {
		await this.transporter
			.sendMail({
				from: `"No Reply" <${process.env.NO_REPLY_EMAIL}>`,
				to,
				subject: subject,
				text: message
			})
			.catch(error => {
				throw new Error(`Email send failed: ${error.message}`);
			});
	}
}
