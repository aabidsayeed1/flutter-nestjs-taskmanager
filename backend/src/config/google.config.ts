import { registerAs } from '@nestjs/config';

export default registerAs('google', () => ({
	firebase: {
		projectId: process.env.GOOGLE_FIREBASE_PROJECT_ID || '',
		privateKey: process.env.GOOGLE_FIREBASE_PRIVATE_KEY || '',
		clientEmail: process.env.GOOGLE_FIREBASE_CLIENT_EMAIL || ''
	}
}));
