import { INestApplication } from '@nestjs/common';
import { DocumentBuilder, OpenAPIObject, SwaggerModule } from '@nestjs/swagger';
import { Test, TestingModule } from '@nestjs/testing';
import { ApiDocumentationBase } from './api-documentation-base';

jest.mock('../../package.json', () => ({
	name: 'Test API',
	description: 'Test API Description',
	version: '1.0.0',
	tag: 'test'
}));

describe('ApiDocumentationBase', () => {
	let app: INestApplication;

	beforeAll(async () => {
		const moduleFixture: TestingModule = await Test.createTestingModule(
			{}
		).compile();

		app = moduleFixture.createNestApplication();
		await app.init();
	});

	afterAll(async () => {
		await app.close();
	});

	it('should initialize Swagger documentation', () => {
		const createDocumentSpy = jest.spyOn(SwaggerModule, 'createDocument');
		const setupSpy = jest.spyOn(SwaggerModule, 'setup');

		ApiDocumentationBase.initApiDocumentation(app);

		const config = new DocumentBuilder()
			.setTitle('Public API Docs')
			.setDescription('Contains only public-related APIs')
			.setVersion('1.0')
			.addBearerAuth()
			.build();

		// Expect createDocument to have been called with the correct app and config
		expect(createDocumentSpy).toHaveBeenCalledWith(app, config);

		const document: OpenAPIObject = createDocumentSpy.mock.results[0].value;

		// Expect setup to have been called with 'api', the app, and the created document
		expect(setupSpy).toHaveBeenCalledWith('api', app, document);
	});
});
