import { Module } from '@nestjs/common';
import { ConfigModule } from '@nestjs/config';
import { NewRelicService } from './new-relic.service';

@Module({
	imports: [ConfigModule],
	providers: [NewRelicService],
	exports: [NewRelicService]
})
export class NewRelicModule {}
