import { Module } from '@nestjs/common';
import { ConfigModule } from '@nestjs/config';
import configuration from '../config/config';
import { VersionCheckController } from './version-check.controller';
import { VersionCheckService } from './version-check.service';

@Module({
	imports: [
		ConfigModule.forRoot({
			load: [configuration]
		})
	],
	providers: [VersionCheckService],
	controllers: [VersionCheckController]
})
export class VersionCheckModule {}
