import { registerAs } from '@nestjs/config';

export default registerAs('app', () => ({
	apiPort: parseInt(process.env.API_PORT || '8000', 10),
	sqsPort: parseInt(process.env.SQS_PORT || '8001', 10),
	jwtSecret: process.env.JWT_SECRET,
	emailVerificationURL: process.env.EMAIL_VERIFICATION_URL,
	global: {
		limit: parseInt(process.env.RATE_LIMIT_GLOBAL_LIMIT || '500', 10),
		duration: parseInt(process.env.RATE_LIMIT_GLOBAL_DURATION || '1', 10)
	},
	otp: {
		limit: parseInt(process.env.RATE_LIMIT_OTP_LIMIT || '5', 10),
		duration: parseInt(process.env.RATE_LIMIT_OTP_DURATION || '60', 10)
	},
	blacklistedIPs: process.env.RATE_LIMIT_BLACKLISTED_IPS
		? process.env.RATE_LIMIT_BLACKLISTED_IPS.split(',')
		: [],
	allowedRegions: process.env.RATE_LIMIT_ALLOWED_REGIONS
		? process.env.RATE_LIMIT_ALLOWED_REGIONS.split(',')
		: [],
	allowedHosts: process.env.ALLOWED_HOSTS
		? process.env.ALLOWED_HOSTS.split(',')
		: []
}));
