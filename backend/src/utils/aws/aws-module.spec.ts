import { Test, TestingModule } from '@nestjs/testing';
import { ConfigModule } from '@nestjs/config';
import { S3Client } from '@aws-sdk/client-s3';
import { SQSClient } from '@aws-sdk/client-sqs';
import { AwsCommonModule } from './aws-module';

jest.mock('@aws-sdk/client-s3');
jest.mock('@aws-sdk/client-sqs');

describe('AwsCommonModule', () => {
	let module: TestingModule;

	beforeEach(async () => {
		module = await Test.createTestingModule({
			imports: [
				ConfigModule.forRoot({
					load: [
						() => ({
							app: {
								region: 'us-east-1',
								accessKeyId: 'test-access-key',
								secretKey: 'test-secret-key'
							}
						})
					]
				}),
				AwsCommonModule
			]
		}).compile();
	});

	it('should be defined', () => {
		expect(module).toBeDefined();
	});

	it('should provide AWS_CREDENTIALS', () => {
		const awsCredentials = module.get('AWS_CREDENTIALS');
		expect(awsCredentials).toEqual({
			region: 'us-east-1',
			credentials: {
				accessKeyId: 'test-access-key',
				secretAccessKey: 'test-secret-key'
			}
		});
	});

	it('should provide S3Client', () => {
		const s3Client = module.get<S3Client>(S3Client);
		expect(s3Client).toBeDefined();
		expect(S3Client).toHaveBeenCalledWith({
			region: 'us-east-1',
			credentials: {
				accessKeyId: 'test-access-key',
				secretAccessKey: 'test-secret-key'
			}
		});
	});

	it('should provide SQSClient', () => {
		const sqsClient = module.get<SQSClient>(SQSClient);
		expect(sqsClient).toBeDefined();
		expect(SQSClient).toHaveBeenCalledWith({
			region: 'us-east-1',
			credentials: {
				accessKeyId: 'test-access-key',
				secretAccessKey: 'test-secret-key'
			}
		});
	});

	it('should export S3Client and SQSClient', () => {
		const exportedProviders = Reflect.getMetadata(
			'exports',
			AwsCommonModule
		);
		expect(exportedProviders).toContain(S3Client);
		expect(exportedProviders).toContain(SQSClient);
	});
});
