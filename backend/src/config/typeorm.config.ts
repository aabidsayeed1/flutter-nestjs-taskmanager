import { registerAs } from '@nestjs/config';
import { DataSource, DataSourceOptions } from 'typeorm';

import * as dotenv from 'dotenv';
dotenv.config({
	path: `${__dirname}/../../envs/.env.${process.env.NODE_ENV || 'dev'}`
});

const config = {
	type: 'postgres',
	host: `${process.env.POSTGRES_HOST}`,
	port: `${process.env.POSTGRES_PORT}`,
	username: `${process.env.POSTGRES_USERNAME}`,
	password: `${process.env.POSTGRES_PASSWORD}`,
	database: `${process.env.POSTGRES_DATABASE}`,
	entities: [__dirname + '/../**/*.entity{.ts,.js}'],
	migrations: [__dirname + '/../migrations/*{.ts,.js}'],
	autoLoadEntities: false,
	synchronize: true,
	logging: true,
	ssl: process.env.SSL_ENABLED === 'true'
};

export default registerAs('typeorm', () => config);
export const connectionSource = new DataSource(config as DataSourceOptions);
