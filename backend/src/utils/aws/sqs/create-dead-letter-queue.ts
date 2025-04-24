import * as dotenv from 'dotenv';
import {
	SQSClient,
	CreateQueueCommand,
	GetQueueAttributesCommand,
	ListQueuesCommand
} from '@aws-sdk/client-sqs';
import { getEnvSpecificQueues } from '@/utils/aws/sqs/sqs-queue.config';
import { QueueConfig } from './interfaces/queue-config.interface';
const env = process.env.NODE_ENV || 'dev';
dotenv.config({
	path: `${__dirname}/../../../../envs/.env.${env}`
});

async function createDLQueue(): Promise<void> {
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

	const queues = getEnvSpecificQueues(env);
	for (const queue of Object.values(queues)) {
		try {
			const dlqName = `${queue.dlqName}`;
			const dlqArn = await checkOrCreateDLQ(sqsClient, dlqName);
			console.log(`Dead Letter Queue ARN for ${queue.name}: ${dlqArn}`);
		} catch (error) {
			console.error(`Failed to process queue: ${queue.name}`, error);
		}
	}
}

async function checkOrCreateDLQ(
	sqsClient: SQSClient,
	dlqName: string
): Promise<string> {
	// List existing queues to check if the DLQ already exists
	const listQueuesCommand = new ListQueuesCommand({
		QueueNamePrefix: dlqName
	});
	const listResponse = await sqsClient.send(listQueuesCommand);
	if (listResponse.QueueUrls && listResponse.QueueUrls.length > 0) {
		// Get the ARN of the existing DLQ
		const dlqUrl = listResponse.QueueUrls[0];
		const getAttributesCommand = new GetQueueAttributesCommand({
			QueueUrl: dlqUrl,
			AttributeNames: ['QueueArn']
		});
		const attributesResponse = await sqsClient.send(getAttributesCommand);

		const dlqArn = attributesResponse.Attributes?.QueueArn;
		if (!dlqArn) {
			throw new Error(
				`Failed to retrieve DLQ ARN for existing queue: ${dlqName}`
			);
		}
		console.log(`DLQ already exists: ${dlqName}`);
		return dlqArn;
	}

	// Create the DLQ if it does not exist
	return await createDLQ(sqsClient, dlqName);
}

async function createDLQ(
	sqsClient: SQSClient,
	dlqName: string
): Promise<string> {
	const command = new CreateQueueCommand({
		QueueName: dlqName,
		Attributes: {
			MessageRetentionPeriod: '1209600' // 14 days (Maximum retention period for SQS messages)
		}
	});

	try {
		const response = await sqsClient.send(command);
		console.log(`DLQ created: ${dlqName}`);

		const dlqUrl = response.QueueUrl;
		if (!dlqUrl) {
			throw new Error(`Failed to retrieve DLQ URL for queue: ${dlqName}`);
		}

		const getAttributesCommand = new GetQueueAttributesCommand({
			QueueUrl: dlqUrl,
			AttributeNames: ['QueueArn']
		});
		const attributesResponse = await sqsClient.send(getAttributesCommand);

		const dlqArn = attributesResponse.Attributes?.QueueArn;
		if (!dlqArn) {
			throw new Error(`Failed to retrieve DLQ ARN for queue: ${dlqName}`);
		}

		return dlqArn;
	} catch (error) {
		console.error(`Failed to create DLQ: ${dlqName}`, error);
		throw error;
	}
}

createDLQueue()
	.then(() => {
		console.log('DLQ check and creation completed successfully');
	})
	.catch(error => {
		console.error('Error creating or checking DLQ:', error);
	});
