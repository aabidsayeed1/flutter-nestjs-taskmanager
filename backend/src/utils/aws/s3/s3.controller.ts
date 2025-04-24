import { Response } from '@/utils/response/decorators/response.decorator';
import {
	Body,
	Controller,
	HttpException,
	HttpStatus,
	NotFoundException,
	Post,
	Res
} from '@nestjs/common';
import { S3Service } from './s3.service';
import { Response as ExpressResponse } from 'express';
import { GetFileDto } from './dto/get-file.dto';

@Controller('s3')
export class S3Controller {
	constructor(private readonly s3Service: S3Service) {}

	@Post('presigned-url')
	@Response('Presigned URL generated successfully')
	async generatePresignedUrl(@Body() body: { key: string }) {
		const { key } = body;

		if (!key) {
			throw new HttpException('Key is required', HttpStatus.BAD_REQUEST);
		}

		try {
			const url = await this.s3Service.generatePresignedUrl(key);
			return { url };
		} catch (error) {
			throw new HttpException(
				`Error generating pre-signed URL: ${error}`,
				HttpStatus.INTERNAL_SERVER_ERROR
			);
		}
	}

	@Post('file')
	@Response('success')
	async getFile(@Body() body: GetFileDto, @Res() res: ExpressResponse) {
		const { key } = body;

		const file = await this.s3Service.getFile(key);

		if (!file) {
			throw new NotFoundException('File not found');
		}

		res.setHeader('Content-Type', file.contentType);
		file.stream.pipe(res);
	}
}
