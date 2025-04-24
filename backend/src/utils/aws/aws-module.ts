import { S3Client } from '@aws-sdk/client-s3';
import { SQSClient } from '@aws-sdk/client-sqs';
import { Module } from '@nestjs/common';
import { ConfigModule, ConfigService } from '@nestjs/config';
@Module({
	imports: [ConfigModule],
	providers: [
		{
			provide: 'AWS_CREDENTIALS',
			useFactory: (configService: ConfigService) => ({
				region: configService.get<string>('app.region'),
				credentials: {
					accessKeyId:
						configService.get<string>('app.accessKeyId') ?? '',
					secretAccessKey:
						configService.get<string>('app.secretKey') ?? ''
				}
			}),
			inject: [ConfigService]
		},
		{
			provide: S3Client,
			useFactory: (awsCredentials: any) => new S3Client(awsCredentials),
			inject: ['AWS_CREDENTIALS']
		},
		{
			provide: SQSClient,
			useFactory: (awsCredentials: any) => new SQSClient(awsCredentials),
			inject: ['AWS_CREDENTIALS']
		}
	],
	exports: [S3Client, SQSClient]
})
export class AwsCommonModule {}
