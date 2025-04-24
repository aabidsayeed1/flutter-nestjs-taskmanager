import { NestFactory } from '@nestjs/core';
import { AppModule } from '../../src/app.module';
import { PerformanceService } from './performance.service';
import { Logger } from '@nestjs/common';

async function bootstrap() {
	const app = await NestFactory.create(AppModule);
	const performanceService = app.get(PerformanceService);

	try {
		await performanceService.initialize();
		Logger.log('Performance initialization completed successfully');
	} catch (error) {
		Logger.error('Error during performance initialization', error);
	} finally {
		await app.close();
	}
}

bootstrap().catch(err => {
	console.error('Error initializing performance module', err);
	process.exit(1);
});
