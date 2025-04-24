import { Injectable } from '@nestjs/common';
import * as newrelic from 'newrelic';

@Injectable()
export class NewRelicService {
	addCustomAttribute(key: string, value: string | number | boolean): void {
		newrelic.addCustomAttribute(key, value);
	}

	recordMetric(name: string, value: number): void {
		newrelic.recordMetric(name, value);
	}

	startSegment(
		name: string,
		record: boolean,
		handler: () => Promise<any>
	): Promise<any> {
		return newrelic.startSegment(name, record, handler);
	}

	noticeError(error: Error): void {
		newrelic.noticeError(error);
	}
}
