import {
	Injectable,
	NestMiddleware,
	HttpException,
	HttpStatus
} from '@nestjs/common';
import { Request, Response, NextFunction } from 'express';
import { RateLimiterMemory, RateLimiterRes } from 'rate-limiter-flexible';
import * as geoip from 'geoip-lite';
import { ConfigService } from '@nestjs/config';

@Injectable()
export class RateLimitingMiddleware implements NestMiddleware {
	private readonly globalRateLimiter: RateLimiterMemory;
	private readonly blacklistedIPs: Set<string>;
	private readonly allowedRegions: Set<string>;

	constructor(private configService: ConfigService) {
		const globalLimit =
			this.configService?.get<number>('rateLimit.global.limit') || 80;
		const globalDuration =
			this.configService?.get<number>('rateLimit.global.duration') || 1;

		this.globalRateLimiter = new RateLimiterMemory({
			points: globalLimit,
			duration: globalDuration
		});

		this.blacklistedIPs = new Set(
			this.configService?.get<string[]>('rateLimit.blacklistedIPs') || []
		);
		this.allowedRegions = new Set(
			this.configService?.get<string[]>('rateLimit.allowedRegions') || []
		);
	}

	async use(req: Request, res: Response, next: NextFunction) {
		const ip = req.ip || '';

		if (ip && this.blacklistedIPs.has(ip)) {
			throw new HttpException('Access denied', HttpStatus.FORBIDDEN);
		}

		const geo = ip ? geoip.lookup(ip) : null;
		if (
			geo &&
			this.allowedRegions.size > 0 &&
			!this.allowedRegions.has(geo.country)
		) {
			throw new HttpException(
				'Access denied from your region',
				HttpStatus.FORBIDDEN
			);
		}

		try {
			if (ip) {
				await this.globalRateLimiter.consume(ip);
			}

			next();
		} catch (error) {
			if (error instanceof RateLimiterRes) {
				const retryAfter = Math.ceil(error.msBeforeNext / 1000) || 1;
				res.set('Retry-After', String(retryAfter));
				throw new HttpException(
					'Too Many Requests',
					HttpStatus.TOO_MANY_REQUESTS
				);
			} else {
				console.error(
					'Unexpected error in rate limiting middleware:',
					error
				);
				throw new HttpException(
					'Internal Server Error',
					HttpStatus.INTERNAL_SERVER_ERROR
				);
			}
		}
	}
}
