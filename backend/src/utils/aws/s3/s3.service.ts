import {
	DeleteObjectCommand,
	GetObjectCommand,
	PutObjectCommand,
	S3Client
} from '@aws-sdk/client-s3';
import { Injectable } from '@nestjs/common';
import { ConfigService } from '@nestjs/config';
import { WinstonLogger } from '../../logger/winston-logger.service';
import { Readable } from 'stream';
import { getSignedUrl } from '@aws-sdk/s3-request-presigner';

@Injectable()
export class S3Service {
	private readonly bucketName: string;
	private readonly cloudFrontDomain: string;
	private s3Client: S3Client;

	constructor(
		private configService: ConfigService,
		private loggerService: WinstonLogger
	) {
		this.s3Client = new S3Client({
			region: this.configService.get<string>('AWS_S3_REGION') || '',
			credentials: {
				accessKeyId:
					this.configService.get<string>('AWS_S3_ACCESS_KEY_ID') ||
					'',
				secretAccessKey:
					this.configService.get<string>('AWS_S3_SECRET_KEY') || ''
			}
		});
		this.bucketName = this.configService.get<string>('AWS_S3_BUCKET') || '';
		this.cloudFrontDomain =
			this.configService.get<string>(
				'AWS_CLOUDFRONT_USER_FILES_DISTRIBUTION_DOMAIN_NAME'
			) || '';
	}

	async uploadFile(fileData: {
		fileName: string;
		file: Express.Multer.File;
	}): Promise<{ coldStorageLink: string; CDNLink: string } | null> {
		try {
			const { fileName, file } = fileData;
			const params = {
				Bucket: this.bucketName,
				Key: fileName,
				Body: file.buffer,
				ContentType: file.mimetype
			};

			await this.s3Client.send(new PutObjectCommand(params));

			const coldStorageLink = `https://${this.bucketName}.s3.amazonaws.com/${fileName}`;
			const cDNLink = `https://${this.cloudFrontDomain}/${fileName}`;
			this.loggerService.log(
				`[S3Service][uploadFile]: Successfully uploaded ${fileName} to S3 bucket: ${this.bucketName}`
			);
			return { coldStorageLink, CDNLink: cDNLink };
		} catch (err) {
			if (err instanceof Error) {
				this.loggerService.error(
					`[S3Service][uploadFile]: Error in uploading file to S3. ${err.message}`,
					err.stack
				);
			} else {
				this.loggerService.error(
					'[S3Service][uploadFile]: Error in uploading file to S3.',
					JSON.stringify(err)
				);
			}
			return null;
		}
	}

	async uploadFiles(
		fileData: Array<{ fileName: string; file: Express.Multer.File }>
	): Promise<{ coldStorageLink: string; CDNLink: string }[]> {
		try {
			const uploadedUrls: { coldStorageLink: string; CDNLink: string }[] =
				[];

			const uploadPromises = fileData.map(async ({ fileName, file }) => {
				const params = {
					Bucket: this.bucketName,
					Key: fileName,
					Body: file.buffer,
					ContentType: file.mimetype
				};

				await this.s3Client.send(new PutObjectCommand(params));

				const coldStorageLink = `https://${this.bucketName}.s3.amazonaws.com/${fileName}`;
				const cDNLink = `https://${this.cloudFrontDomain}/${fileName}`;
				uploadedUrls.push({ coldStorageLink, CDNLink: cDNLink });

				this.loggerService.log(
					`[S3Service][uploadFiles]: Successfully uploaded ${fileName} to S3 bucket: ${this.bucketName}`
				);
			});
			await Promise.all(uploadPromises);
			return uploadedUrls;
		} catch (err) {
			if (err instanceof Error) {
				this.loggerService.error(
					`[S3Service][uploadFiles]: Error in uploading files to S3. ${err.message}`,
					err.stack
				);
			} else {
				this.loggerService.error(
					'[S3Service][uploadFiles]: Error in uploading files to S3.',
					JSON.stringify(err)
				);
			}
			return [];
		}
	}

	async deleteFile(fileKey: string) {
		try {
			const command = new DeleteObjectCommand({
				Bucket: this.bucketName,
				Key: fileKey
			});

			await this.s3Client.send(command);
			this.loggerService.log(
				`[S3Service][deleteFile]: Successfully deleted ${fileKey} from S3 bucket: ${this.bucketName}`
			);
		} catch (error) {
			this.loggerService.error(
				'[S3Service][deleteFile]: Error in deleting file from S3.',
				JSON.stringify(error)
			);
		}
	}

	async getFile(
		fileKey: string
	): Promise<{ stream: Readable; contentType: string } | null> {
		try {
			const command = new GetObjectCommand({
				Bucket: this.bucketName,
				Key: fileKey
			});

			const response = await this.s3Client.send(command);

			if (response && response.Body && response.ContentType) {
				this.loggerService.log(
					`[S3Service][getFile]: Successfully retrieved ${fileKey} from S3 bucket: ${this.bucketName}`
				);

				return {
					stream: response.Body as Readable,
					contentType: response.ContentType
				};
			} else {
				this.loggerService.error(
					`[S3Service][getFile]: No content found for ${fileKey} in S3 bucket: ${this.bucketName}`
				);
				return null;
			}
		} catch (error) {
			this.loggerService.error(
				'[S3Service][getFile]: Error in retrieving file from S3.',
				JSON.stringify(error)
			);
			return null;
		}
	}

	async generatePresignedUrl(objectKey: string): Promise<string> {
		const command = new GetObjectCommand({
			Bucket: this.bucketName,
			Key: objectKey
		});

		const url = await getSignedUrl(this.s3Client, command, {
			expiresIn: 3600
		});

		return url;
	}
}
