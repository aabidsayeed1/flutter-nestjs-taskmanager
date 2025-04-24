import { registerAs } from '@nestjs/config';
import { config as dotenvConfig } from 'dotenv';
import * as fs from 'fs';

const filePath =
    process.env.NODE_ENV === 'test'
        ? `${__dirname}/../../envs/.env.${process.env.NODE_ENV || 'test'}`
        : `${__dirname}/../../envs/.env.dev`;

dotenvConfig({
	path: filePath
});
console.log('Loading .env file:', filePath);
export default registerAs('database', () => {
	const sslEnabled =
		process.env.NODE_ENV === 'development' ||
		process.env.NODE_ENV === 'dev' ||
		process.env.NODE_ENV === 'test'
			? false
			: true; // If true, use certificates

	const dbSslCAPath =
		process.env.NODE_ENV === 'qa'
			? 'certificates/isrgrootx1.pem'
			: 'certificates/ap-south-1-bundle.pem';

	// SSL config for valid certificates (for QA, UAT, and Production)
	const sslConfig = sslEnabled
		? {
				ssl: {
					rejectUnauthorized: !sslEnabled, // Reject unauthorized for all except local (self-signed)
					ca:
						dbSslCAPath && fs.existsSync(dbSslCAPath)
							? fs.readFileSync(dbSslCAPath)
							: undefined
				}
			}
		: {};

	return {
		type: 'postgres',
		host: process.env.POSTGRES_HOST || '',
		port: parseInt(process.env.POSTGRES_PORT || '', 10),
		username: process.env.POSTGRES_USERNAME || '',
		password: process.env.POSTGRES_PASSWORD || '',
		database: process.env.POSTGRES_DATABASE || '',
		entities: [__dirname + '/../**/*.entity{.ts,.js}'],
		migrations: [__dirname + '/../migrations/*{.ts,.js}'],
		synchronize: true,
		logging: process.env.NODE_ENV !== 'production',
		migrationsTableName: 'migrations_typeorm',
		extra: {
			max: 30,
			min: 2,
			idleTimeoutMillis: 30000,
			connectionTimeoutMillis: 2000,
			...sslConfig // Apply the SSL configuration if enabled
		}
	};
});
