import { QueueConfig } from '@/utils/aws/sqs/interfaces/queue-config.interface';
import { DefaultServiceHandler } from './handlers/default-service.handler';
import { SendEmailServiceHandler } from './handlers/send-email-service.handler';
// import { DocumentProcessHandler } from './handlers/document-process-handler';
export const queues: Record<string, QueueConfig> = {
	SendEmailService: {
		name: 'SendEmailService',
		delaySeconds: 0,
		handler: SendEmailServiceHandler,
		maxReceiveCount: 5,
		messageRetentionPeriod: 86400,
		dlqName: 'DukeDeadLetterQueue'
	},
	SendNotificationService: {
		name: 'SendNotificationService',
		delaySeconds: 0,
		handler: DefaultServiceHandler,
		maxReceiveCount: 5,
		messageRetentionPeriod: 86400,
		dlqName: 'DukeDeadLetterQueue'
	},
};

export function getEnvSpecificQueues(env: string): Record<string, QueueConfig> {
	const prefix = env.charAt(0).toUpperCase() + env.slice(1);
	const envSpecificQueues: Record<string, QueueConfig> = {};

	Object.entries(queues).forEach(([key, value]) => {
		envSpecificQueues[key] = {
			name: `${prefix}${value.name}`,
			delaySeconds: value.delaySeconds,
			handler: value.handler,
			maxReceiveCount: value.maxReceiveCount,
			messageRetentionPeriod: value.messageRetentionPeriod,
			dlqName: `${prefix}${value.dlqName}`
		};
	});

	return envSpecificQueues;
}
