import { Injectable, NestMiddleware } from '@nestjs/common';
import { Request, Response, NextFunction } from 'express';

@Injectable()
export default class CspReportMiddleware implements NestMiddleware {
	use(req: Request, res: Response, next: NextFunction) {
		if (req.is('application/csp-report')) {
			let data = '';

			req.on('data', (chunk: any) => {
				data += chunk;
			});

			req.on('end', () => {
				try {
					req.body = JSON.parse(data);
				} catch (err) {
					console.error('Error parsing CSP report:', err);
				}
				next();
			});
		} else {
			next();
		}
	}
}
