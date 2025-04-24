import * as dotenv from 'dotenv';
import {
	SQSClient,
	CreateQueueCommand,
	ListQueuesCommand,
	SetQueueAttributesCommand
} from '@aws-sdk/client-sqs';
import { getEnvSpecificQueues } from '@/utils/aws/sqs/sqs-queue.config';
import { QueueConfig } from './interfaces/queue-config.interface';

const env = process.env.NODE_ENV || 'dev';
dotenv.config({
	path: `${__dirname}/../../../../envs/.env.${env}`
});

async function createQueues(): Promise<void> {
	const region = process.env.AWS_SQS_REGION;
	const accessKeyId = process.env.AWS_SQS_ACCESS_KEY_ID;
	const secretAccessKey = process.env.AWS_SQS_SECRET_KEY;

	if (!region || !accessKeyId || !secretAccessKey) {
		throw new Error(
			'Missing AWS configuration: Ensure aws.sqs.region, aws.sqs.accessKeyId, and aws.sqs.secretKey are defined in your environment variables.'
		);
	}

	const sqsClient = new SQSClient({
		region,
		credentials: {
			accessKeyId,
			secretAccessKey
		}
	});

	console.log('Creating queues for environment:', env);
	const queues = getEnvSpecificQueues(env);

	for (const queue of Object.values(queues)) {
		try {
			await checkOrCreateQueue(sqsClient, queue);
			console.log(`Queue checked/created: ${queue.name}`);
		} catch (error) {
			console.error(`Failed to process queue: ${queue.name}`, error);
		}
	}
}

async function checkOrCreateQueue(
	sqsClient: SQSClient,
	queue: QueueConfig
): Promise<void> {
	const existingQueueUrl = await checkIfQueueExists(sqsClient, queue.name);

	if (existingQueueUrl) {
		console.log(`Queue already exists: ${queue.name}`);
		return;
	}

	const createdQueueUrl = await createQueue(sqsClient, queue);
	await associateDLQ(sqsClient, queue, createdQueueUrl);
}

async function checkIfQueueExists(
	sqsClient: SQSClient,
	queueName: string
): Promise<string | null> {
	const listQueuesCommand = new ListQueuesCommand({
		QueueNamePrefix: queueName
	});
	const listResponse = await sqsClient.send(listQueuesCommand);

	if (listResponse.QueueUrls && listResponse.QueueUrls.length > 0) {
		return listResponse.QueueUrls[0];
	}
	return null;
}

async function createQueue(
	sqsClient: SQSClient,
	queue: QueueConfig
): Promise<string> {
	const command = new CreateQueueCommand({
		QueueName: queue.name,
		Attributes: {
			DelaySeconds: queue.delaySeconds.toString(),
			MessageRetentionPeriod: queue.messageRetentionPeriod.toString() // 1 day
		}
	});

	const response = await sqsClient.send(command);
	return response.QueueUrl!;
}

async function associateDLQ(
	sqsClient: SQSClient,
	queue: QueueConfig,
	queueUrl: string
): Promise<void> {
	const region = process.env.AWS_SQS_REGION;
	const accountId = process.env.AWS_SQS_ACCOUNT_ID;
	if (!queue.dlqName) {
		console.log(`No DLQ configured for queue: ${queue.name}`);
		return;
	}

	const setAttributesCommand = new SetQueueAttributesCommand({
		QueueUrl: queueUrl,
		Attributes: {
			RedrivePolicy: JSON.stringify({
				maxReceiveCount: 5,
				deadLetterTargetArn: `arn:aws:sqs:${region}:${accountId}:${queue.dlqName}`
			})
		}
	});

	await sqsClient.send(setAttributesCommand);
	console.log(`DLQ ${queue.dlqName} associated with queue: ${queue.name}`);
}

createQueues()
	.then(() => {
		console.log('All queues checked/created successfully');
	})
	.catch(error => {
		console.error('Error creating queues:', error);
	});
