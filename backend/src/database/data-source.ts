import { DataSource, DataSourceOptions } from 'typeorm';
import databaseConfig from '../config/database.config';

const dbConfig = databaseConfig();

export const dataSourceOptions: DataSourceOptions = {
	...dbConfig,
	ssl: false,
	synchronize: true,
	type: 'postgres'
};
export const dataSource = new DataSource(dataSourceOptions);
