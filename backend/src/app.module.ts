import {
	DynamicModule,
	MiddlewareConsumer,
	Module,
	NestModule
} from '@nestjs/common';
import { ConfigModule } from '@nestjs/config';
import { ServeStaticModule } from '@nestjs/serve-static';
import { AcceptLanguageResolver, I18nModule, QueryResolver } from 'nestjs-i18n';
import * as path from 'path';
import { VersionCheckModule } from './app-versioning/version-check.module';
import { AppController } from './app.controller';
import { AppService } from './app.service';
import appConfig from './config/app.config';
import awsConfig from './config/aws.config';
import configuration from './config/config';
import databaseConfig from './config/database.config';
import googleConfig from './config/google.config';
import typeorm from './config/typeorm.config';
import { CspModule } from './csp/csp.module';
import { DatabaseModule } from './database/database.module';
import { FeedbackModule } from './feedback/feedback.module';
import { HealthModule } from './health/health.module';
import { NotificationsModule } from './notifications/notifications.module';
import { ReferralModule } from './referral/referral.module';
import { UserModule } from './user/user.module';
import { AwsCommonModule } from './utils/aws/aws-module';
import { LoggerModule } from './utils/logger/logger-module';
import { LoggingMiddleware } from './utils/middlewares/logRequest.middleware';
import { MiddlewareModule } from './utils/middlewares/middlewares.module';
import { RateLimitingMiddleware } from './utils/middlewares/rate-limiting.middleware';
import { NewRelicModule } from './utils/new-relic/new-relic.module';

import { join } from 'path';
import CspReportMiddleware from './csp/csp-report.middleware';

import { ReportToMiddleware } from './csp/csp-report-to.middleware';

import { APP_INTERCEPTOR } from '@nestjs/core';
import { AppUpdateModule } from './app-update/app-update.module';
import { AppUpdateService } from './app-update/app-update.service';
import { AuthModule } from './auth/auth.module';
import { I18nHelperModule } from './i18n-helper/i18n-helper.module';
import { PerformanceModule } from './performance/performance.module';
import { SqsModule } from './utils/aws/sqs/sqs.module';
import { ResultTransformInterceptor } from './utils/response/response.utils';
import { sanitizarController } from './utils/sanitizar/sanitizar.controller';
import { TasksModule } from './tasks/tasks.module';
const envPath = path.resolve(
	__dirname,
	'../../envs/.env.' + (process.env.NODE_ENV || 'dev')
);

@Module({
	imports: [
		ServeStaticModule.forRoot({
			rootPath: join(__dirname, '../../', 'src/csp'),
			serveRoot: '/csp'
		}),
		ConfigModule.forRoot({
			isGlobal: true,
			load: [
				appConfig,
				awsConfig,
				googleConfig,
				databaseConfig,
				typeorm,
				configuration
			],
			envFilePath: [envPath]
		}),
		LoggerModule,
		MiddlewareModule,
		DatabaseModule,
		NewRelicModule,
		UserModule,
		HealthModule,
		AwsCommonModule,
		AuthModule,
		VersionCheckModule,
		ReferralModule,
		FeedbackModule,
		I18nModule.forRoot({
			fallbackLanguage: 'en',
			loaderOptions: {
				path: path.join(__dirname, '/../i18n/'),
				watch: true
			},

			resolvers: [
				{ use: QueryResolver, options: ['lang', 'locale', 'l'] },
				AcceptLanguageResolver
			]
		}),
		NotificationsModule,
		CspModule,
		PerformanceModule,
		I18nHelperModule,
		AppUpdateModule,
		TasksModule
	],
	controllers: [AppController, sanitizarController],
	providers: [
		AppService,
		{
			provide: APP_INTERCEPTOR,
			useClass: ResultTransformInterceptor
		},
		AppUpdateService
	]
})
export class AppModule implements NestModule {
	configure(consumer: MiddlewareConsumer) {
		consumer
			.apply(LoggingMiddleware, RateLimitingMiddleware)
			.forRoutes('*');
		consumer.apply(CspReportMiddleware).forRoutes('csp-report');
		consumer.apply(ReportToMiddleware).forRoutes('csp-report');
	}
	static register(config: { isSqsEnabled: boolean }): DynamicModule {
		return {
			module: AppModule,
			imports: [SqsModule.forRoot(config.isSqsEnabled)]
		};
	}
}
