import { QueueHandler } from './queue-handler.interface';

export interface QueueConfig {
	name: string;
	delaySeconds: number;
	handler: new (...args: any[]) => QueueHandler;
	maxReceiveCount: number;
	messageRetentionPeriod: number;
	dlqName: string;
}
