import { Module } from '@nestjs/common';
import { ConfigModule, ConfigService } from '@nestjs/config';
import { TypeOrmModule, TypeOrmModuleOptions } from '@nestjs/typeorm';
import databaseConfig from '../config/database.config';

@Module({
	imports: [
		ConfigModule.forRoot({
			load: [databaseConfig]
		}),
		TypeOrmModule.forRootAsync({
			imports: [ConfigModule],
			useFactory: async (
				configService: ConfigService
			): Promise<TypeOrmModuleOptions> => {
				const dbConfig = configService.get('database');
				return {
					type: 'postgres',
					host: dbConfig.host,
					port: dbConfig.port,
					username: dbConfig.username,
					password: dbConfig.password,
					database: dbConfig.database,
					entities: dbConfig.entities,
					migrations: dbConfig.migrations,
					// ssl: dbConfig.ssl,
					synchronize: dbConfig.synchronize,
					// logging: dbConfig.logging,
					migrationsTableName: dbConfig.migrationsTableName,
					extra: dbConfig.extra
				};
			},
			inject: [ConfigService]
		})
	]
})
export class DatabaseModule {}
