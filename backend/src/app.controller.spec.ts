import { INestApplication } from '@nestjs/common';
import { Test, TestingModule } from '@nestjs/testing';
import request from 'supertest';
import { AppController } from './app.controller';
import { AppService } from './app.service';
import { I18nHelperService } from './i18n-helper/i18n-helper.service';
import { mockI18nHelperService } from './utils/test-utils';

describe('AppController', () => {
	let app: INestApplication;
	// eslint-disable-next-line @typescript-eslint/no-unused-vars
	let appService: AppService;

	beforeAll(async () => {
		const moduleFixture: TestingModule = await Test.createTestingModule({
			controllers: [AppController],
			providers: [
				AppService,
				{ provide: I18nHelperService, useValue: mockI18nHelperService }
			]
		}).compile();

		app = moduleFixture.createNestApplication();
		await app.init();
		appService = moduleFixture.get<AppService>(AppService);
	});

	afterAll(async () => {
		await app.close();
	});

	describe('GET /', () => {
		it('should return "Hello World!"', async () => {
			const response = await request(app.getHttpServer())
				.get('/')
				.expect(200);

			expect(response.text).toBe('Hello World!');
		});
	});

	describe('GET /error', () => {
		it('should throw an InternalServerErrorException', async () => {
			const response = await request(app.getHttpServer())
				.get('/error')
				.expect(500);

			expect(response.body).toEqual({
				statusCode: 500,
				message: 'This is a test error',
				error: 'Internal Server Error'
			});
		});
	});
});
