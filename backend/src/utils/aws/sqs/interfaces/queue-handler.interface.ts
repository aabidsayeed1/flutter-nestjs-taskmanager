import { Message } from '@aws-sdk/client-sqs';

export interface QueueHandler {
	handle(message: Message): Promise<void>;
}
