import { Injectable } from '@nestjs/common';
import { Message } from '@aws-sdk/client-sqs';
import { QueueHandler } from '../interfaces/queue-handler.interface';

@Injectable()
export class DefaultServiceHandler implements QueueHandler {
	constructor() {}

	async handle(message: Message): Promise<void> {
		const messageBody = JSON.parse(message.Body || '{}');
		console.log('Processed message from SendEmailService:', messageBody);
	}
}
