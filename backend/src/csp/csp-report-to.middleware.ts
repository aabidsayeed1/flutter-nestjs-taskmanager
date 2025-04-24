import { Injectable, NestMiddleware } from '@nestjs/common';
import { Request, Response, NextFunction } from 'express';

@Injectable()
export class ReportToMiddleware implements NestMiddleware {
	use(req: Request, res: Response, next: NextFunction) {
		res.setHeader(
			'Report-To',
			JSON.stringify({
				group: 'csp-endpoint',
				max_age: 10886400,
				endpoints: [{ url: 'http://localhost:3000/csp-report' }],
				include_subdomains: true
			})
		);
		next();
	}
}
