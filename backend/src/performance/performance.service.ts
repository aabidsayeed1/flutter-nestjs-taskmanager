import { Injectable, Logger } from '@nestjs/common';
import { DataSource } from 'typeorm';
import { promises as fs, writeFileSync } from 'fs';
import * as dotenv from 'dotenv';

dotenv.config({
	path: `${__dirname}/../../envs/.env.${process.env.NODE_ENV || 'dev'}`
});

// change threshold value according to project need
const POOL_SIZE = process.env.PERFORMANCE_POOL_SIZE || '';
const MAX_ROWS = process.env.PERFORMANCE_MAX_ROWS || '';
const MAX_COST = process.env.PERFORMANCE_MAX_COST || '';

@Injectable()
export class PerformanceService {
	logger: any;
	constructor(private readonly dataSource: DataSource) {}
	private extractParameters(query: string): any[] {
		const regex = /\$(\d+)/g;
		const matches = [];
		let match;
		while ((match = regex.exec(query)) !== null) {
			matches.push(match[0]);
		}
		return matches;
	}

	private assignDefaultValues(parameters: string[]): Record<string, any> {
		const defaultValues: Record<string, any> = {};
		parameters.forEach(param => {
			defaultValues[param] = null;
		});
		return defaultValues;
	}
	async initialize() {
		await this.ensurePgStatStatementsEnabled();
		await this.ensureConnectionPoolSize();
		await this.performVacuum();
		const lastVacuum = await this.getLastVacuumExecution();
		writeFileSync(
			'src/performance/performance-json/last_vacuum.json',
			JSON.stringify(lastVacuum, null, 2)
		);
		Logger.log(
			`Last Vacuum execution details saved to ${'last_vacuum.json'}`
		);

		const foreignKeysWithoutIndex = await this.getForeignKeysWithoutIndex();
		writeFileSync(
			'src/performance/performance-json/foreignKeysWithoutIndex.json',
			JSON.stringify(foreignKeysWithoutIndex, null, 2)
		);
		Logger.log(
			`Foreignkeys without index table details saved to ${'foreignKeysWithoutIndex.json'}`
		);

		const unusedIndexes = await this.getUnusedIndexes();
		writeFileSync(
			'src/performance/performance-json/unusedIndexes.json',
			JSON.stringify(unusedIndexes, null, 2)
		);
		Logger.log(
			`Unused indexes table details saved to ${'unusedIndexes.json'}`
		);

		const tablesWithSeqScans = await this.getTablesWithSeqScans();
		writeFileSync(
			'src/performance/performance-json/tablesWithSeqScans.json',
			JSON.stringify(tablesWithSeqScans, null, 2)
		);
		Logger.log(
			`Table with Seq scan details saved to ${'tablesWithSeqScans.json'}`
		);

		const slowQueries = await this.getSlowQueries();
		const processedQueries = slowQueries.map(
			(queryData: { query: any }) => {
				const { query } = queryData;
				const parameters = this.extractParameters(query);

				const defaultValues = this.assignDefaultValues(parameters);

				return {
					...queryData,
					parameters,
					defaultValues
				};
			}
		);

		writeFileSync(
			'src/performance/performance-json/slowQueries.json',
			JSON.stringify(processedQueries, null, 2)
		);
		Logger.log(`Slow queries details saved to ${'slowQueries.json'}`);

		const highCPUIOQueries = await this.getHighCPUIOQueries();
		writeFileSync(
			'src/performance/performance-json/highCPUIOQueries.json',
			JSON.stringify(highCPUIOQueries, null, 2)
		);
		Logger.log(
			`High Cpu queries details saved to ${'highCPUIOQueries.json'}`
		);

		const slowAvgQueries = await this.getSlowAvgQueries();
		writeFileSync(
			'src/performance/performance-json/slowAvgQueries.json',
			JSON.stringify(slowAvgQueries, null, 2)
		);
		Logger.log(
			`Slow Avg Queries details saved to ${'slowAvgQueries.json'}`
		);

		await this.analyzeQueryPerformance();
	}

	async getLastVacuumExecution() {
		const result = await this.dataSource.query(`;
		    SELECT schemaname, relname as table_name, last_vacuum, last_analyze,
		           last_autovacuum, last_autoanalyze, n_live_tup, n_dead_tup
		    FROM pg_stat_user_tables;
		  `);
		return result;
	}

	async getForeignKeysWithoutIndex() {
		const result = await this.dataSource.query(`
	    SELECT c.conrelid::regclass AS "table",
	           string_agg(a.attname, ',' ORDER BY x.n) AS columns,
	           pg_catalog.pg_size_pretty(pg_catalog.pg_relation_size(c.conrelid)) AS size,
	           c.conname AS constraint,
	           c.confrelid::regclass AS referenced_table
	    FROM pg_catalog.pg_constraint c
	    CROSS JOIN LATERAL unnest(c.conkey) WITH ORDINALITY AS x(attnum, n)
	    JOIN pg_catalog.pg_attribute a
	      ON a.attnum = x.attnum AND a.attrelid = c.conrelid
	    WHERE NOT EXISTS (
	        SELECT 1 FROM pg_catalog.pg_index i
	        WHERE i.indrelid = c.conrelid AND i.indpred IS NULL
	        AND (i.indkey::smallint[])[0:cardinality(c.conkey)-1] OPERATOR(pg_catalog.@>) c.conkey
	    ) AND c.contype = 'f'
	    GROUP BY c.conrelid, c.conname, c.confrelid
	    ORDER BY pg_catalog.pg_relation_size(c.conrelid) DESC;
	  `);
		return result;
	}

	async getUnusedIndexes() {
		const result = await this.dataSource.query(`
	    SELECT s.schemaname, s.relname AS tablename, s.indexrelname AS indexname,
	           pg_relation_size(s.indexrelid) AS index_size
	    FROM pg_catalog.pg_stat_user_indexes s
	    JOIN pg_catalog.pg_index i ON s.indexrelid = i.indexrelid
	    WHERE s.idx_scan = 0
	    AND 0 <> ALL (i.indkey)
	    AND NOT i.indisunique
	    AND NOT EXISTS (
	        SELECT 1 FROM pg_catalog.pg_constraint c
	        WHERE c.conindid = s.indexrelid
	    )
	    AND NOT EXISTS (
	        SELECT 1 FROM pg_catalog.pg_inherits AS inh
	        WHERE inh.inhrelid = s.indexrelid
	    )
	    ORDER BY pg_relation_size(s.indexrelid) DESC;
	  `);
		return result;
	}

	async getTablesWithSeqScans() {
		const result = await this.dataSource.query(`
	    SELECT schemaname, relname, seq_scan, seq_tup_read, idx_scan,
	           seq_tup_read / seq_scan AS avg
	    FROM pg_stat_user_tables
	    WHERE seq_scan > 0
	    ORDER BY seq_tup_read DESC;
	  `);
		return result;
	}

	async getSlowQueries() {
		const result = await this.dataSource.query(`
	    SELECT queryid, query, total_exec_time, calls, mean_exec_time
        FROM pg_stat_statements
        ORDER BY total_exec_time DESC;`);
		Logger.log('Slow queries:', JSON.stringify(result, null, 2));
		return result;
	}

	async getHighCPUIOQueries() {
		const result = await this.dataSource.query(`
	    SELECT queryid, query, calls, mean_exec_time, shared_blks_hit
	    FROM pg_stat_statements
	    ORDER BY shared_blks_hit DESC;
	  `);
		Logger.log(
			'High CPU/IO load queries:',
			JSON.stringify(result, null, 2)
		);
		return result;
	}

	async getSlowAvgQueries() {
		const result = await this.dataSource.query(`
	    SELECT query, total_exec_time, calls, mean_exec_time
	    FROM pg_stat_statements
	    ORDER BY mean_exec_time DESC;
	  `);
		Logger.log('Slow avg queries:', JSON.stringify(result, null, 2));
		return result;
	}

	async ensurePgStatStatementsEnabled() {
		const result = await this.dataSource.query(
			`SELECT * FROM pg_extension WHERE extname = 'pg_stat_statements';`
		);
		if (result.length === 0) {
			await this.dataSource.query(`CREATE EXTENSION pg_stat_statements;`);
			Logger.log('pg_stat_statements extension enabled');
		} else {
			Logger.log('pg_stat_statements extension already enabled');
		}
	}

	async ensureConnectionPoolSize() {
		const maxConnections = await this.dataSource.query(
			`SELECT setting AS max_connections FROM pg_settings WHERE name = 'max_connections';`
		);
		const poolSize = POOL_SIZE;

		if (maxConnections[0].max_connections < poolSize) {
			Logger.warn(
				`Connection pool size is too high! Max connections: ${maxConnections[0].max_connections}`
			);
		} else {
			Logger.log('Connection pool size is appropriate.');
		}
	}

	async performVacuum() {
		try {
			Logger.log('Running VACUUM FULL ANALYZE');
			await this.dataSource.query('VACUUM FULL ANALYZE;');
			Logger.log('VACUUM ANALYZE completed successfully');
		} catch (error) {
			Logger.error('Error running VACUUM ANALYZE', error);
		}
	}

	async analyzeQueryPerformance() {
		try {
			const data = await fs.readFile(
				'src/performance/performance-json/slowQueries.json',
				'utf-8'
			);
			const slowQueries = JSON.parse(data);

			let index = 0;
			const reportArray = [];
			for (const queryData of slowQueries) {
				const data = {
					queryId: '',
					query: '',
					result: {
						isSequentialScanDetected: false,
						iSTotalCostHigh: false,
						isRowScanHigh: false
					},
					filePath: ''
				};
				data.queryId = queryData.queryid;
				const query = queryData.query;
				if (!query || typeof query !== 'string') {
					console.log('Invalid query detected:', queryData);
					continue;
				}

				if (
					query.startsWith('CREATE') ||
					query.startsWith('DROP') ||
					query.startsWith('ALTER') ||
					query.startsWith('VACUUM') ||
					query.startsWith('<') ||
					query.startsWith('SET')
				) {
					console.log(`Skipping DDL query: ${query}`);
					continue;
				}
				index += 1;
				await this.runExplainAnalyze(queryData, index, data);
				if (data.query != '') reportArray.push(data);
			}
			await writeFileSync(
				`src/performance/performance-json/reports/reports.json`,
				JSON.stringify(reportArray, null, 2)
			);
		} catch (error) {
			this.logger.error('Error reading or parsing the JSON file', error);
		}
	}
	private replaceParameters(
		query: string,
		parameters: string[],
		defaultValues: Record<string, any>
	): string {
		let modifiedQuery = query;
		parameters.forEach(param => {
			const value = defaultValues[param];
			let replacement: string;

			if (typeof value === 'string') {
				replacement = `'${value.replace(/'/g, "''")}'`;
			} else if (typeof value === 'boolean') {
				replacement = value ? 'TRUE' : 'FALSE';
			} else if (value === null) {
				replacement = 'NULL';
			} else {
				replacement = value.toString();
			}
			const regex = new RegExp(`\\${param}\\b`, 'g');
			modifiedQuery = modifiedQuery.replace(regex, replacement);
		});

		return modifiedQuery;
	}

	async runExplainAnalyze(
		queryData: {
			queryId: any;
			query: any;
			parameters: any;
			defaultValues: any;
		},
		index: number,
		data: any
	) {
		try {
			const { query, parameters, defaultValues } = queryData;
			const modifiedQuery = this.replaceParameters(
				query,
				parameters,
				defaultValues
			);
			const explainQuery = `EXPLAIN (ANALYZE, COSTS, VERBOSE, BUFFERS, FORMAT JSON) ${modifiedQuery}`;
			const resultObj = {
				queryId: data.queryId,
				result: []
			};
			const result = await this.dataSource.query(explainQuery);
			resultObj.result = result;
			data.filePath = `performance/performance-json/analyze/analyze${index}.json`;
			await writeFileSync(
				`src/performance/performance-json/analyze/analyze${index}.json`,
				JSON.stringify(resultObj, null, 2)
			);
			const resultJson: any = result;
			if (
				resultJson &&
				Array.isArray(resultJson) &&
				resultJson.length > 0 &&
				resultJson[0]?.['QUERY PLAN']
			) {
				const executionPlan = resultJson[0]['QUERY PLAN'];
				this.checkRedFlags(executionPlan, modifiedQuery, index, data);
			} else {
				Logger.warn('No valid execution plan found.');
			}
		} catch (error) {
			Logger.error('Error running EXPLAIN ANALYZE:', error);
		}
	}

	async checkRedFlags(
		plan: any,
		modifiedQuery: string,
		index: number,
		data: any
	) {
		const executionPlan = plan[0];
		data.query = modifiedQuery;
		if (executionPlan['Plan']['Node Type'] === 'Seq Scan') {
			data.result.isSequentialScanDetected = true;
			Logger.error('Sequential scan detected! Consider adding an index.');
		}
		if (executionPlan['Plan']['Total Cost'] > MAX_COST) {
			data.result.iSTotalCostHigh = true;
			Logger.warn(
				'High query cost detected! Consider optimizing the query.'
			);
		}
		if (executionPlan['Plan']['Plan Rows'] > MAX_ROWS) {
			data.result.isRowScanHigh = true;
			Logger.warn(
				'Query is accessing more than max rows! Consider optimization.'
			);
		}
	}
}
