import { Module } from '@nestjs/common';
import { PerformanceService } from './performance.service';
import { JsonToHtmlService } from './json-to-html.service';

@Module({
	providers: [PerformanceService, JsonToHtmlService],
	exports: [PerformanceService, JsonToHtmlService]
})
export class PerformanceModule {}
