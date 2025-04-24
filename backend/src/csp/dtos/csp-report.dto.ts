import { IsString, IsUrl, IsOptional, IsNumber } from 'class-validator';

export class CspReportDto {
	@IsUrl()
	'document-uri': string;

	@IsString()
	referrer!: string;

	@IsString()
	'violated-directive': string;

	@IsString()
	'effective-directive': string;

	@IsString()
	'original-policy': string;

	@IsString()
	disposition!: string;

	@IsUrl()
	'blocked-uri': string;

	@IsNumber()
	'status-code': number;

	@IsOptional()
	@IsString()
	'script-sample'?: string;
}

export class ReportDto {
	'csp-report': CspReportDto;
}
