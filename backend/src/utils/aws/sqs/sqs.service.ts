import { SQSClient, SendMessageCommand } from '@aws-sdk/client-sqs';
import { Injectable, OnApplicationBootstrap } from '@nestjs/common';
import { ConfigService } from '@nestjs/config';
import { ModuleRef } from '@nestjs/core';
import { Consumer } from 'sqs-consumer';
import { WinstonLogger } from '../../logger/winston-logger.service';
import { QueueConfig } from './interfaces/queue-config.interface';
import { SendMessageParams } from './interfaces/send-message-params.interface';
import { getEnvSpecificQueues } from './sqs-queue.config';

@Injectable()
export class SqsService implements OnApplicationBootstrap {
	private sqsClient: SQSClient;
	private readonly queues: Record<string, QueueConfig>;
	private static shouldInitialize = false;

	constructor(
		private configService: ConfigService,
		private loggerService: WinstonLogger,
		private readonly moduleRef: ModuleRef,
	) {
		this.sqsClient = new SQSClient({
			region: this.configService.get<string>('aws.sqs.region'),
			endpoint: this.configService.get<string>('aws.sqs.queueUrl'),
			credentials: {
				accessKeyId:
					this.configService.get<string>('AWS_SQS_ACCESS_KEY_ID') ||
					'elasticmq',
				secretAccessKey:
					this.configService.get<string>('AWS_SQS_SECRET_KEY') ||
					'elasticmq'
			}
		});
		this.queues = getEnvSpecificQueues(process.env.NODE_ENV || 'dev');
	}


	async onApplicationBootstrap() {
		if (SqsService.shouldInitialize) {
			console.log('-----------sqs');
			await this.initializeQueues();
		}
	}
	static enableInitialization() {
		SqsService.shouldInitialize = true;
	}
	static disableInitialization() {
		SqsService.shouldInitialize = false;
	}
	private async initializeQueues() {
		for (const queueKey in this.queues) {
			if (this.queues.hasOwnProperty(queueKey)) {
				const queue = this.queues[queueKey];
				await this.receiveMessage(queue);
			}
		}
	}

	// async onModuleInit() {
	// 	for (const queueKey in this.queues) {
	// 		if (this.queues.hasOwnProperty(queueKey)) {
	// 			const queue = this.queues[queueKey];
	// 			await this.receiveMessage(queue);
	// 		}
	// 	}
	// }

	async sendMessage({
		queueKey,
		messageBody
	}: SendMessageParams): Promise<void> {
		this.loggerService.log('send message to queue', {
			queueKey,
			messageBody
		});
		const queueConfig = this.queues[queueKey];
		if (!queueConfig) {
			this.loggerService.error(
				`Queue configuration not found for key: ${queueKey}`
			);
			return;
		}

		const { name, delaySeconds } = queueConfig;
		const queueUrl = `${this.configService.get<string>('aws.sqs.queueUrl')}/${name}`;

		const params = {
			QueueUrl: queueUrl,
			MessageBody: JSON.stringify(messageBody),
			DelaySeconds: delaySeconds || 0
		};

		try {
			const command = new SendMessageCommand(params);
			const response = await this.sqsClient.send(command);
			this.loggerService.log('[SQS] Message sent to', {
				name,
				response
			});
			console.log(`[SQS] Message sent to ${name}:`, response.MessageId);
		} catch (error) {
			this.loggerService.error('[SQS] Error sending message', {
				name,
				error
			});
			console.error(`[SQS] Error sending message to ${name}:`, error);
		}
	}

	private async receiveMessage(queue: QueueConfig) {
		const { name, handler } = queue;
		const queueUrl = `${this.configService.get<string>('aws.sqs.queueUrl')}/${name}`;

		const consumer = Consumer.create({
			queueUrl,
			handleMessage: async message => {
				try {
					const handlerInstance = this.moduleRef.get(handler, {
						strict: false
					});
					await handlerInstance.handle(message);
					this.loggerService.log(
						`Message processed successfully: ${message.MessageId}`
					);
				} catch (error) {
					this.loggerService.error(
						`Error processing message: ${message.MessageId}`,
						error
					);
					throw error;
				}
			},
			sqs: this.sqsClient
		});

		consumer.on('error', error => {
			this.loggerService.error(
				`Error in SQS consumer for queue ${name}`,
				error
			);
		});

		consumer.on('processing_error', error => {
			this.loggerService.error(
				`Processing error in queue ${name}`,
				error
			);
		});

		consumer.on('timeout_error', error => {
			this.loggerService.error(`Timeout error in queue ${name}`, error);
		});

		consumer.start();
		this.loggerService.log(`Started SQS consumer for queue ${name}`);
	}
}
