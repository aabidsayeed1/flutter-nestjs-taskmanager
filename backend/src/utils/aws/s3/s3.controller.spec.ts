import { Test, TestingModule } from '@nestjs/testing';
import { S3Controller } from './s3.controller';
import { S3Service } from './s3.service';
import { Response as ExpressResponse } from 'express';
import { Readable } from 'stream';
import { GetFileDto } from './dto/get-file.dto';
import { NotFoundException } from '@nestjs/common';

describe('S3Controller', () => {
	let controller: S3Controller;
	let s3Service: S3Service;

	beforeEach(async () => {
		const module: TestingModule = await Test.createTestingModule({
			controllers: [S3Controller],
			providers: [
				{
					provide: S3Service,
					useValue: {
						getFile: jest.fn()
					}
				}
			]
		}).compile();

		controller = module.get<S3Controller>(S3Controller);
		s3Service = module.get<S3Service>(S3Service);
	});

	describe('getFile', () => {
		let res: ExpressResponse;

		beforeEach(() => {
			res = {
				setHeader: jest.fn(),
				status: jest.fn().mockReturnThis(),
				json: jest.fn(),
				send: jest.fn(),
				end: jest.fn(),
				pipe: jest.fn()
			} as unknown as ExpressResponse;
		});

		it('should return the file stream and set the appropriate header', async () => {
			const key = 'test-file.pdf';
			const fileStream = new Readable();
			fileStream.push('file content');
			fileStream.push(null);
			const file = {
				contentType: 'application/pdf',
				stream: fileStream
			};

			jest.spyOn(s3Service, 'getFile').mockResolvedValue(file);
			fileStream.pipe = jest.fn();

			const body: GetFileDto = { key };

			await controller.getFile(body, res);

			expect(s3Service.getFile).toHaveBeenCalledWith(key);
			expect(res.setHeader).toHaveBeenCalledWith(
				'Content-Type',
				file.contentType
			);
			expect(file.stream.pipe).toHaveBeenCalledWith(res);
		});

		it('should throw NotFoundException if file is not found', async () => {
			const key = 'non-existent-file.pdf';

			jest.spyOn(s3Service, 'getFile').mockResolvedValue(null);

			const body: GetFileDto = { key };

			await expect(controller.getFile(body, res)).rejects.toThrow(
				NotFoundException
			);
			expect(s3Service.getFile).toHaveBeenCalledWith(key);
			expect(res.setHeader).not.toHaveBeenCalled();
		});
	});
});
