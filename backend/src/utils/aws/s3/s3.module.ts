import { Module } from '@nestjs/common';
import { S3Service } from './s3.service';
import { AwsCommonModule } from '../aws-module';
import { S3Controller } from './s3.controller';
@Module({
	imports: [AwsCommonModule],
	providers: [S3Service],
	exports: [S3Service],
	controllers: [S3Controller]
})
export class S3Module {}
