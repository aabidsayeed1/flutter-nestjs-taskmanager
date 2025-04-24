import { Injectable, PipeTransform } from '@nestjs/common';
import sanitizeHtml from 'sanitize-html';

@Injectable()
export class SanitizeHtmlPipe implements PipeTransform {
	transform(value: any) {
		if (typeof value === 'string') {
			return sanitizeHtml(value, {
				allowedTags: [],
				allowedAttributes: {}
			});
		}
		return value;
	}
}
