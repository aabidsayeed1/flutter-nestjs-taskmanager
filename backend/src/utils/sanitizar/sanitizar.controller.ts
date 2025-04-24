import { Controller, Post, Body } from '@nestjs/common';
import { SanitizeHtmlPipe } from './sanitize-html.pipe';

@Controller('sanitizar')
export class sanitizarController {
	@Post('submit')
	handleSubmit(@Body('content', SanitizeHtmlPipe) content: string) {
		return { sanitizedContent: content };
	}
}
