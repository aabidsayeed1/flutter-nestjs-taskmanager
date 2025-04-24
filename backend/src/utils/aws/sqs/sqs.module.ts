import { NotificationsModule } from '@/notifications/notifications.module';
import { DynamicModule, Module } from '@nestjs/common';
import { DefaultServiceHandler } from './handlers/default-service.handler';
import { SendEmailServiceHandler } from './handlers/send-email-service.handler';
import { SqsService } from './sqs.service';
@Module({})
export class SqsModule {
	static forRoot(isSqsEnabled: boolean): DynamicModule {
		console.log(
			'isSqsEnabled',
			isSqsEnabled || process.env.NODE_ENV === 'dev'
		);
		if (isSqsEnabled || process.env.NODE_ENV === 'dev') {
			SqsService.enableInitialization();
			return {
				module: SqsModule,
				imports: [NotificationsModule],
				providers: [
					SqsService,
					DefaultServiceHandler,
					SendEmailServiceHandler,
				],
				exports: [
					SqsService,
					DefaultServiceHandler,
					SendEmailServiceHandler,
				]
			};
		} else {
			// If SQS is not enabled, return an empty module
			SqsService.disableInitialization();
			return {
				module: SqsModule,
				imports: [],
				providers: [],
				exports: []
			};
		}
	}
}
