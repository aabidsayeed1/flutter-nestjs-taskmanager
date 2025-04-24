import { Injectable, NestMiddleware } from '@nestjs/common';
import { NextFunction, Request, Response } from 'express';
import { v7 as uuidv7 } from 'uuid';
import { WinstonLogger } from '../logger/winston-logger.service';
import { TraceContext } from './trace.context';
// import * as newrelic from 'newrelic';

@Injectable()
export class LoggingMiddleware implements NestMiddleware {
	constructor(private readonly logger: WinstonLogger) {}

	use(req: Request, res: Response, next: NextFunction) {
		TraceContext.run(() => {
			const traceID = (req.headers['trace-id'] as string) || uuidv7();
			const sessionID =
				(req.headers['session-id'] as string) ||
				req.cookies['sessionID'] ||
				uuidv7();

			TraceContext.setTraceId(traceID);
			TraceContext.setSessionId(sessionID);

			req.headers['trace-id'] = traceID;
			req.headers['session-id'] = sessionID;

			res.setHeader('trace-id', traceID);
			res.setHeader('session-id', sessionID);

			const start = Date.now();

			// Add New Relic custom attributes
			// newrelic.addCustomAttribute('traceID', traceID);
			// newrelic.addCustomAttribute('sessionID', sessionID);

			res.on('finish', () => {
				const duration = Date.now() - start;
				const { method, originalUrl, ip } = req;
				const { statusCode } = res;

				const logMessage = `[TraceID: ${traceID}] [SessionID: ${sessionID}] [Method: ${method}] [URL: ${originalUrl}] [Status: ${statusCode}] [Duration: ${duration}ms] [IP: ${ip}]`;

				const logObject = {
					traceID,
					sessionID,
					method,
					url: originalUrl,
					statusCode,
					duration,
					ip,
					userAgent: req.headers['user-agent']
				};

				// Record metrics in New Relic
				// newrelic.recordMetric(`Custom/API${originalUrl}`, duration);
				// newrelic.addCustomAttribute('statusCode', statusCode);

				if (statusCode >= 500) {
					this.logger.error(logMessage, logObject);
					// newrelic.noticeError(
					// 	new Error(`Server Error: ${statusCode}`)
					// );
				} else if (statusCode >= 400) {
					this.logger.warn(logMessage, logObject);
					// newrelic.noticeError(
					// 	new Error(`Client Error: ${statusCode}`)
					// );
				} else {
					this.logger.log(logMessage, logObject);
				}
			});

			next();
		});
	}
}
