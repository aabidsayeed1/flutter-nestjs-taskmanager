import { Injectable } from '@nestjs/common';
import { Message } from '@aws-sdk/client-sqs';
import { QueueHandler } from '../interfaces/queue-handler.interface';
import { NotificationService } from '@/notifications/services/notification.service';

@Injectable()
export class SendEmailServiceHandler implements QueueHandler {
	constructor(private readonly notificationService: NotificationService) {}
	async handle(message: Message): Promise<void> {
		const messageBody = JSON.parse(message.Body || '{}');
		await this.notificationService.send(
			messageBody?.type,
			messageBody?.context,
			messageBody?.data
		);
		console.log('Processed message from SendEmailService:', messageBody);
	}
}
