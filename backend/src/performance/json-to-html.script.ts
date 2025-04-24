import { NestFactory } from '@nestjs/core';
import { AppModule } from '../../src/app.module';
import { Logger } from '@nestjs/common';
import { JsonToHtmlService } from './json-to-html.service';

async function bootstrap() {
	const app = await NestFactory.create(AppModule);
	const JsontohtmlService = app.get(JsonToHtmlService);

	try {
		await JsontohtmlService.createHtmlFromJson();
		Logger.log('json to html module initialization completed successfully');
	} catch (error) {
		Logger.error('Error during json to html module initialization', error);
	} finally {
		await app.close();
	}
}

bootstrap().catch(err => {
	console.error('Error json to html module:', err);
	process.exit(1);
});
