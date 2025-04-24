import { Global, Module } from '@nestjs/common';
import { WinstonLogger } from './winston-logger.service';
@Global()
@Module({
	providers: [WinstonLogger],
	exports: [WinstonLogger]
})
export class LoggerModule {}
