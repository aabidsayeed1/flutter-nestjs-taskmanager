import { Test, TestingModule } from '@nestjs/testing';
import { ConfigModule, ConfigService } from '@nestjs/config';
import { TypeOrmModule } from '@nestjs/typeorm';
import { DatabaseModule } from './database.module';

// Mock TypeOrmModule
jest.mock('@nestjs/typeorm', () => ({
	TypeOrmModule: {
		forRootAsync: jest.fn().mockReturnValue({
			module: class DynamicModule {},
			providers: []
		})
	}
}));

describe('DatabaseModule', () => {
	let module: TestingModule;
	let configService: ConfigService;

	beforeAll(async () => {
		module = await Test.createTestingModule({
			imports: [
				ConfigModule.forRoot({
					isGlobal: true,
					load: [
						() => ({
							database: {
								postgres: {
									type: 'postgres',
									host: 'localhost',
									port: 5433,
									username: 'postgres',
									password: 'postgres',
									database: 'postgres',
									entities: [
										__dirname + '/../**/*.entity{.ts,.js}'
									],
									migrations: [
										__dirname + '/../migration/*{.ts,.js}'
									],
									synchronize: false,
									logging: true
								}
							}
						})
					]
				}),
				DatabaseModule
			]
		}).compile();

		configService = module.get<ConfigService>(ConfigService);
	});

	it('should be defined', () => {
		expect(module).toBeDefined();
	});

	it('should provide correct database configuration', () => {
		const dbConfig = configService.get('database.postgres');
		expect(dbConfig).toEqual({
			type: 'postgres',
			host: 'localhost',
			port: 5433,
			username: 'postgres',
			password: 'postgres',
			database: 'postgres',
			entities: expect.arrayContaining([
				expect.stringContaining('/../**/*.entity{.ts,.js}')
			]),
			migrations: expect.arrayContaining([
				expect.stringContaining('/../migration/*{.ts,.js}')
			]),
			synchronize: false,
			logging: true
		});
	});

	it('should call TypeOrmModule.forRootAsync with correct options', () => {
		expect(TypeOrmModule.forRootAsync).toHaveBeenCalledWith(
			expect.objectContaining({
				useFactory: expect.any(Function),
				inject: [ConfigService]
			})
		);
	});
});
