import { Injectable } from '@nestjs/common';
import { InjectRepository } from '@nestjs/typeorm';
import { Repository } from 'typeorm';
import { CspReport } from './entities/csp-report.entity';

@Injectable()
export class CspService {
	constructor(
		@InjectRepository(CspReport)
		private readonly cspReportRepository: Repository<CspReport>
	) {}

	async createCspReport(cspReportDto: {
		documentUri: string;
		referrer?: string;
		blockedUri: string;
		violatedDirective: string;
		originalPolicy: string;
	}): Promise<CspReport> {
		try {
			const report = this.cspReportRepository.create(cspReportDto);
			return await this.cspReportRepository.save(report);
		} catch (error) {
			console.error('Error saving CSP report:', error);
			throw new Error('Could not save CSP report');
		}
	}

	async findAll() {
		try {
			const report = this.cspReportRepository.find();
			return report;
		} catch (error) {
			console.error('Error saving CSP report:', error);
			throw new Error('Could not save CSP report');
		}
	}
}
