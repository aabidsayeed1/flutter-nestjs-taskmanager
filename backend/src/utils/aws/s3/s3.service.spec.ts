import { Test, TestingModule } from '@nestjs/testing';
import { ConfigService } from '@nestjs/config';
import {
	PutObjectCommand,
	PutObjectCommandOutput,
	DeleteObjectCommand,
	GetObjectCommand
} from '@aws-sdk/client-s3';
import { S3Service } from './s3.service';
import { WinstonLogger } from '../../logger/winston-logger.service';
import { Readable } from 'stream';

jest.mock('@aws-sdk/client-s3', () => {
	const mockSend = jest.fn();
	return {
		S3Client: jest.fn(() => ({
			send: mockSend
		})),
		PutObjectCommand: jest.fn(),
		DeleteObjectCommand: jest.fn(),
		GetObjectCommand: jest.fn()
	};
});

describe('S3Service', () => {
	let service: S3Service;
	let loggerService: WinstonLogger;
	let mockSend: jest.Mock;

	beforeEach(async () => {
		mockSend = jest.fn();
		const module: TestingModule = await Test.createTestingModule({
			providers: [
				S3Service,
				{
					provide: ConfigService,
					useValue: {
						get: jest.fn((key: string) => {
							const config: Record<string, string> = {
								AWS_S3_ACCESS_KEY_ID: 'test-access-key',
								AWS_S3_SECRET_KEY: 'test-secret-key',
								AWS_S3_BUCKET: 'test-bucket',
								AWS_CLOUDFRONT_USER_FILES_DISTRIBUTION_DOMAIN_NAME:
									'test-domain.cloudfront.net'
							};
							return config[key];
						})
					}
				},
				{
					provide: WinstonLogger,
					useValue: {
						log: jest.fn(),
						error: jest.fn()
					}
				}
			]
		}).compile();

		service = module.get<S3Service>(S3Service);
		loggerService = module.get<WinstonLogger>(WinstonLogger);

		(service as any).s3Client = {
			send: mockSend
		};
	});

	afterEach(() => {
		jest.clearAllMocks();
	});

	it('should be defined', () => {
		expect(service).toBeDefined();
	});

	describe('uploadFile', () => {
		it('should upload a file successfully', async () => {
			const mockFile = {
				fieldname: 'file',
				originalname: 'test.jpg',
				encoding: '7bit',
				mimetype: 'image/jpeg',
				buffer: Buffer.from('test file content'),
				size: 18
			} as Express.Multer.File;

			const mockPutObjectOutput: PutObjectCommandOutput = {
				$metadata: {}
			};

			mockSend.mockResolvedValueOnce(mockPutObjectOutput);

			const result = await service.uploadFile({
				fileName: 'test.jpg',
				file: mockFile
			});

			expect(result).toEqual({
				coldStorageLink:
					'https://test-bucket.s3.amazonaws.com/test.jpg',
				CDNLink: 'https://test-domain.cloudfront.net/test.jpg'
			});
			expect(mockSend).toHaveBeenCalledWith(expect.any(PutObjectCommand));
			expect(loggerService.log).toHaveBeenCalledWith(
				'[S3Service][uploadFile]: Successfully uploaded test.jpg to S3 bucket: test-bucket'
			);
		});

		// ... (other tests remain the same)
	});

	describe('uploadFiles', () => {
		it('should upload multiple files successfully', async () => {
			const mockFiles = [
				{
					fileName: 'test1.jpg',
					file: {
						fieldname: 'file',
						originalname: 'test1.jpg',
						encoding: '7bit',
						mimetype: 'image/jpeg',
						buffer: Buffer.from('test file content 1'),
						size: 20
					} as Express.Multer.File
				},
				{
					fileName: 'test2.jpg',
					file: {
						fieldname: 'file',
						originalname: 'test2.jpg',
						encoding: '7bit',
						mimetype: 'image/jpeg',
						buffer: Buffer.from('test file content 2'),
						size: 20
					} as Express.Multer.File
				}
			];

			const mockPutObjectOutput: PutObjectCommandOutput = {
				$metadata: {}
			};

			mockSend.mockResolvedValue(mockPutObjectOutput);

			const result = await service.uploadFiles(mockFiles);

			expect(result).toEqual([
				{
					coldStorageLink:
						'https://test-bucket.s3.amazonaws.com/test1.jpg',
					CDNLink: 'https://test-domain.cloudfront.net/test1.jpg'
				},
				{
					coldStorageLink:
						'https://test-bucket.s3.amazonaws.com/test2.jpg',
					CDNLink: 'https://test-domain.cloudfront.net/test2.jpg'
				}
			]);
			expect(mockSend).toHaveBeenCalledTimes(2);
			expect(loggerService.log).toHaveBeenCalledTimes(2);
		});

		// ... (other tests remain the same)
	});

	describe('deleteFile', () => {
		it('should delete a file from S3', async () => {
			mockSend.mockResolvedValueOnce({});

			const fileKey = 'test.txt';

			await service.deleteFile(fileKey);

			expect(mockSend).toHaveBeenCalledWith(
				expect.any(DeleteObjectCommand)
			);
			expect(loggerService.log).toHaveBeenCalledWith(
				'[S3Service][deleteFile]: Successfully deleted test.txt from S3 bucket: test-bucket'
			);
		});

		it('should log an error if deletion fails', async () => {
			const mockError = new Error('S3 delete error');
			mockSend.mockRejectedValue(mockError);

			const fileKey = 'test.txt';

			await service.deleteFile(fileKey);

			expect(mockSend).toHaveBeenCalledWith(
				expect.any(DeleteObjectCommand)
			);
			expect(loggerService.error).toHaveBeenCalledWith(
				'[S3Service][deleteFile]: Error in deleting file from S3.',
				JSON.stringify(mockError)
			);
		});
	});

	describe('getFile', () => {
		it('should retrieve a PDF file successfully', async () => {
			const mockFileKey = 'example.pdf';
			const mockStream = new Readable();
			mockStream.push('mock content');
			mockStream.push(null);

			const mockResponse = {
				Body: mockStream,
				ContentType: 'application/pdf'
			};

			mockSend.mockResolvedValue(mockResponse);

			const result = await service.getFile(mockFileKey);

			expect(mockSend).toHaveBeenCalledWith(expect.any(GetObjectCommand));
			expect(result).toEqual({
				stream: mockStream,
				contentType: 'application/pdf'
			});
			expect(loggerService.log).toHaveBeenCalledWith(
				`[S3Service][getFile]: Successfully retrieved ${mockFileKey} from S3 bucket: test-bucket`
			);
		});

		it('should return null if the PDF file content is missing', async () => {
			const mockFileKey = 'missing.pdf';
			const mockResponse = { Body: null, ContentType: null };

			mockSend.mockResolvedValue(mockResponse);

			const result = await service.getFile(mockFileKey);

			expect(mockSend).toHaveBeenCalledWith(expect.any(GetObjectCommand));
			expect(result).toBeNull();
			expect(loggerService.error).toHaveBeenCalledWith(
				`[S3Service][getFile]: No content found for ${mockFileKey} in S3 bucket: test-bucket`
			);
		});

		it('should return null and log an error if an exception is thrown while retrieving a PDF file', async () => {
			const mockFileKey = 'error.pdf';
			const mockError = new Error('S3 error');

			mockSend.mockRejectedValue(mockError);

			const result = await service.getFile(mockFileKey);

			expect(mockSend).toHaveBeenCalledWith(expect.any(GetObjectCommand));
			expect(result).toBeNull();
			expect(loggerService.error).toHaveBeenCalledWith(
				'[S3Service][getFile]: Error in retrieving file from S3.',
				JSON.stringify(mockError)
			);
		});
	});
});
