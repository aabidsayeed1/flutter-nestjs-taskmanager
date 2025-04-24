import { Injectable, LoggerService } from '@nestjs/common';
import { ConfigService } from '@nestjs/config';
import * as fs from 'fs';
import * as winston from 'winston';

// Commenting for now to send logs on AWS during test and building

// import WinstonCloudWatch = require('winston-cloudwatch');
// import { AwsCredentialIdentity } from '@aws-sdk/types';
import { TraceContext } from '../middlewares/trace.context';

@Injectable()
export class WinstonLogger implements LoggerService {
	private readonly logger: winston.Logger;

	constructor(private configService: ConfigService) {
		const awsRegion =
			this.configService?.get<string>('aws.cloudwatch.region') ?? '';
		const logGroupName =
			this.configService?.get<string>('aws.cloudwatch.logGroupName') ??
			'';
		const logStreamName =
			this.configService?.get<string>('aws.cloudwatch.logStreamName') ??
			'';
		const accessKeyId =
			this.configService?.get<string>('aws.cloudwatch.accessKeyId') ?? '';
		const secretKey =
			this.configService?.get<string>('aws.cloudwatch.secretKey') ?? '';

		console.log(
			'AWS Credentials->',
			awsRegion,
			accessKeyId,
			secretKey,
			logGroupName,
			logStreamName
		);

		// Commenting for now to send logs on AWS during test and building
		// const credentials: AwsCredentialIdentity = {
		// 	accessKeyId: accessKeyId,
		// 	secretAccessKey: secretKey
		// };

		const transports: winston.transport[] = [
			new winston.transports.File({
				level: 'error',
				filename: `logs/error.log`,
				format: winston.format.combine(
					winston.format.timestamp(),
					winston.format.json()
				)
			}),
			new winston.transports.File({
				level: 'info',
				filename: `logs/info.log`,
				format: winston.format.combine(
					winston.format.timestamp(),
					winston.format.json()
				)
			})
		];

		if (
			awsRegion &&
			logGroupName &&
			logStreamName &&
			accessKeyId &&
			secretKey
		) {
			// Commenting for now to send logs on AWS during test and building
			// const cloudWatchConfig = {
			// 	logGroupName: logGroupName,
			// 	logStreamName: logStreamName,
			// 	awsOptions: {
			// 		credentials: credentials,
			// 		region: awsRegion
			// 	},
			// 	jsonMessage: true
			// };
			// transports.push(
			// 	new WinstonCloudWatch({
			// 		...cloudWatchConfig,
			// 		level: 'info'
			// 	}),
			// 	new WinstonCloudWatch({
			// 		...cloudWatchConfig,
			// 		level: 'error'
			// 	})
			// );
		}

		this.logger = winston.createLogger({
			format: winston.format.combine(
				winston.format.timestamp({
					format: 'YYYY-MM-DD HH:mm:ss'
				}),
				winston.format.errors({ stack: true }),
				winston.format.splat(),
				winston.format.json()
			),
			transports: transports
		});

		if (this.checkFileSize(`logs/info.log`)) {
			this.initializeLogRotation(`logs/info.log`);
		}

		if (this.checkFileSize(`logs/error.log`)) {
			this.initializeLogRotation(`logs/error.log`);
		}
	}

	private checkFileSize(filePath: string): boolean {
		const fileSizeLimit = 100 * 1024 * 1024; // 20 MB in bytes

		try {
			const stats = fs.statSync(filePath);
			const fileSize = stats.size;

			if (fileSize > fileSizeLimit) {
				return true;
			}
		} catch (err) {
			// File does not exist or other error
			return false;
		}

		return false;
	}

	private initializeLogRotation(filePath: string) {
		fs.stat(filePath, err => {
			if (err) {
				return;
			}

			const newFilePath = `${filePath}_${new Date().toISOString()}`;
			fs.rename(filePath, newFilePath, renameErr => {
				if (renameErr) {
					this.error(`Failed to rename log file: ${renameErr}`);
				}
			});
		});
	}

	private getLogObject(message: string, context?: any) {
		const traceID = TraceContext.getTraceId();
		const sessionID = TraceContext.getSessionId();
		return {
			traceID,
			sessionID,
			message,
			context: context || {}
		};
	}

	log(message: string, context?: any) {
		this.logger.info(this.getLogObject(message, context));
	}

	error(message: string, context?: any) {
		this.logger.error(this.getLogObject(message, context));
	}

	warn(message: string, context?: any) {
		this.logger.warn(this.getLogObject(message, context));
	}

	debug(message: string, context?: any) {
		this.logger.debug(this.getLogObject(message, context));
	}

	verbose(message: string, context?: any) {
		this.logger.verbose(this.getLogObject(message, context));
	}
	// log(message: string, context?: string) {
	// 	this.logger.info({
	// 		level: 'info',
	// 		message,
	// 		context: context
	// 	});
	// }

	// error(message: string, request?: any, trace?: any) {
	// 	let context;
	// 	if (request) {
	// 		context = {
	// 			Request: {
	// 				url: request.url,
	// 				params: request.params,
	// 				body: request.body,
	// 				query: request.query,
	// 				ip: request.ip
	// 			},
	// 			environment: process.env.ENV,
	// 			userInfo: `userId:${request.user?.userId}`
	// 		};
	// 	}
	// 	this.logger.error({
	// 		level: 'error',
	// 		message,
	// 		trace: trace,
	// 		context
	// 	});
	// }

	// warn(message: string, context?: string) {
	// 	this.logger.warn({
	// 		level: 'warn',
	// 		message,
	// 		context: context
	// 	});
	// }

	// debug(message: string, context?: string) {
	// 	this.logger.debug({
	// 		level: 'debug',
	// 		message,
	// 		context: context
	// 	});
	// }

	// verbose(message: string, context?: string) {
	// 	this.logger.verbose({
	// 		level: 'verbose',
	// 		message,
	// 		context
	// 	});
	// }
}
