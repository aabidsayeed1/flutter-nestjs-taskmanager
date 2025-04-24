import { Controller, Body, Get, Post } from '@nestjs/common';
import { CspService } from './csp.service';

@Controller('csp-report')
export class CspController {
	constructor(private readonly cspService: CspService) {}

	@Post()
	async reportCspViolation(@Body() body: any) {
		await this.cspService.createCspReport({
			documentUri: body['csp-report']['blocked-uri'],
			referrer: body['csp-report']['referrer'],
			blockedUri: body['csp-report']['blocked-uri'],
			violatedDirective: body['csp-report']['violated-directive'],
			originalPolicy: body['csp-report']['original-policy']
		});
		return { status: 'success' };
	}

	@Get()
	async getReport() {
		const reports = await this.cspService.findAll();
		return reports;
	}
}
