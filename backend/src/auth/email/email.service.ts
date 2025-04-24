import { Injectable } from '@nestjs/common';
import { ConfigService } from '@nestjs/config';
import axios from 'axios';

@Injectable()
export class EmailService {
	constructor(private configService: ConfigService) {}

	/**
	 * Simulates sending a verification email by making a POST request to the verification endpoint.
	 *
	 * IMPORTANT: This is a temporary implementation for testing the authentication flow.
	 * In a production environment, this method should be replaced with actual email sending logic
	 * using a third-party email service provider (e.g., SendGrid, AWS SES, Mailgun).
	 *
	 * Current behavior:
	 * - Instead of sending an email, it makes a POST request to the verification endpoint.
	 * - This simulates the user clicking on a verification link in their email.
	 *
	 * Future implementation considerations:
	 * - Integrate with a real email service provider.
	 * - Create an HTML email template for verification emails.
	 * - Implement email queuing for better performance and reliability.
	 */
	async sendVerificationEmail(to: string, token: string) {
		const verificationUrl = 'http://localhost:3000/auth/verify-email';
		await this.sendSimulatedEmail(
			to,
			token,
			verificationUrl,
			'verification'
		);
	}

	async sendForgotPasswordEmail(to: string, token: string) {
		const resetPasswordUrl =
			'http://localhost:3000/auth/verify-reset-password';
		await this.sendSimulatedEmail(
			to,
			token,
			resetPasswordUrl,
			'password reset'
		);
	}

	private async sendSimulatedEmail(
		to: string,
		token: string,
		url: string,
		type: string
	) {
		try {
			await axios.post(`${url}?token=${token}`);
			console.log(
				`${type.charAt(0).toUpperCase() + type.slice(1)} request sent for ${to} with token ${token}`
			);
		} catch (error) {
			console.error(`Error sending ${type} request:`, error);
			throw new Error(`Failed to send ${type} request`);
		}
	}
}
