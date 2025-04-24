import { DataSource } from 'typeorm';
import { dataSourceOptions } from './data-source';

describe('DataSource Configuration', () => {
	it('should have correct dataSourceOptions', () => {
		expect(dataSourceOptions).toEqual({
			type: 'postgres',
			host: expect.any(String),
			port: expect.any(Number),
			username: expect.any(String),
			password: expect.any(String),
			database: expect.any(String),
			entities: expect.arrayContaining([
				expect.stringContaining('/../**/*.entity{.ts,.js}')
			]),
			migrations: expect.arrayContaining([
				expect.stringContaining('/../migrations/*{.ts,.js}')
			]),
			synchronize: true,
			logging: true,
			ssl: false,
			extra: expect.objectContaining({
				max: expect.any(Number),
				min: expect.any(Number),
				idleTimeoutMillis: expect.any(Number),
				connectionTimeoutMillis: expect.any(Number)
			}),
			migrationsTableName: expect.any(String)
		});
	});

	it('should instantiate DataSource with correct options', () => {
		const dataSource = new DataSource(dataSourceOptions);
		expect(dataSource.options).toEqual(
			expect.objectContaining(dataSourceOptions)
		);
	});
});
