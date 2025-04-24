import { Injectable } from '@nestjs/common';
import * as fs from 'fs';
import * as path from 'path';

@Injectable()
export class JsonToHtmlService {
	private getFilePath(file: string) {
		return path.join(__dirname, '..', file);
	}

	private inputJsonPath = path.join(
		__dirname,
		'..',
		'performance/performance-json/reports/reports.json'
	);
	private highCPUIOJsonPath = path.join(
		__dirname,
		'..',
		'performance/performance-json/highCPUIOQueries.json'
	);
	private foreignKeysJsonPath = path.join(
		__dirname,
		'..',
		'performance/performance-json/foreignKeysWithoutIndex.json'
	);
	private tableWithSeqScansJsonPath = path.join(
		__dirname,
		'..',
		'performance/performance-json/tablesWithSeqScans.json'
	);
	private lastVacuumJsonPath = path.join(
		__dirname,
		'..',
		'performance/performance-json/last_vacuum.json'
	);

	private SlowQueriesJsonPath = path.join(
		__dirname,
		'..',
		'performance/performance-json/slowQueries.json'
	);

	private SlowAvgQueriesJsonPath = path.join(
		__dirname,
		'..',
		'performance/performance-json/slowAvgQueries.json'
	);

	private UnUsedIndexesJsonPath = path.join(
		__dirname,
		'..',
		'performance/performance-json/unusedIndexes.json'
	);

	private outputHtmlPath = path.join(__dirname, '..', 'reports.html');

	async createHtmlFromJson(): Promise<void> {
		try {
			await fs.promises.writeFile(this.outputHtmlPath, '');

			let htmlContent = this.generateHtml(
				await this.getJsonData(this.inputJsonPath),
				this.inputJsonPath
			);
			await fs.promises.appendFile(this.outputHtmlPath, htmlContent);

			htmlContent = this.generateHtmlForHighCPUIOQueries(
				await this.getJsonData(this.highCPUIOJsonPath),
				this.highCPUIOJsonPath
			);
			await fs.promises.appendFile(this.outputHtmlPath, htmlContent);

			htmlContent = this.generateHtmlForForeignKeys(
				await this.getJsonData(this.foreignKeysJsonPath),
				this.foreignKeysJsonPath
			);
			await fs.promises.appendFile(this.outputHtmlPath, htmlContent);

			htmlContent = this.generateHtmlForSeqScans(
				await this.getJsonData(this.tableWithSeqScansJsonPath),
				this.tableWithSeqScansJsonPath
			);
			await fs.promises.appendFile(this.outputHtmlPath, htmlContent);

			htmlContent = this.generateHtmlForLastVacuum(
				await this.getJsonData(this.lastVacuumJsonPath),
				this.lastVacuumJsonPath
			);
			await fs.promises.appendFile(this.outputHtmlPath, htmlContent);

			htmlContent = this.generateHtmlForSlowQueries(
				await this.getJsonData(this.SlowQueriesJsonPath),
				this.SlowQueriesJsonPath
			);
			await fs.promises.appendFile(this.outputHtmlPath, htmlContent);

			htmlContent = this.generateHtmlForSlowAvgQueries(
				await this.getJsonData(this.SlowAvgQueriesJsonPath),
				this.SlowAvgQueriesJsonPath
			);
			await fs.promises.appendFile(this.outputHtmlPath, htmlContent);

			htmlContent = this.generateHtmlForUnUsedIndexesQueries(
				await this.getJsonData(this.UnUsedIndexesJsonPath),
				this.UnUsedIndexesJsonPath
			);
			await fs.promises.appendFile(this.outputHtmlPath, htmlContent);

			console.log('HTML file created successfully');
		} catch (error) {
			console.error('Error while creating HTML file:', error);
		}
	}

	private async getJsonData(filePath: string): Promise<any> {
		const jsonData = await fs.promises.readFile(filePath, 'utf8');
		return JSON.parse(jsonData);
	}

	private generateHtml(data: any, path: string): string {
		let html = `
    <h1>EXPLAIN (ANALYZE, COSTS, VERBOSE, BUFFERS, FORMAT JSON) </h1>
    <p>View the JSON data: <a href="${path}" download>View JSON</a></p>
    <table>
        <thead>
            <tr>
                <th>QueryId</th>
                <th>Query</th>
                <th>Value</th>
            </tr>
        </thead>
        <tbody>`;

		for (const item of data) {
			html += `
                <tr>
                    <td><a href="${this.getFilePath(item.filePath)}" download>${item.queryId}</a></td>
                    <td style="width:40%;overflow:scroll">${item.query}</td>
                    <td>${JSON.stringify(item.result)}</td>
                </tr>
               `;
		}

		html += `
            </tbody>
        </table>`;
		return html;
	}

	private generateHtmlForHighCPUIOQueries(data: any, path: string): string {
		let html = `
        <h1>High CPU/IO Queries</h1>
    <p>View the JSON data: <a href="${path}" download>View JSON</a></p>
        <table style=" width: 100%;
  table-layout: fixed;
  border-collapse: collapse;">
            <thead>
                <tr >
                    <th>QueryId</th>
                    <th>Query</th>
                    <th>Calls</th>
                    <th>Mean Exec Time</th>
                    <th>Shared Blocks Hit</th>
                </tr>
              
            </thead>
            <tbody>`;

		for (const item of data) {
			html += `
                <tr style="width: 40%;
    white-space: nowrap;
    overflow: scroll;
    margin-top:15px">
                    <td>${item.queryid}</td>
                    <td style="width:40%;overflow:scroll">${item.query}</td>
                    <td>${item.calls}</td>
                    <td>${item.mean_exec_time}</td>
                    <td>${item.shared_blks_hit}</td>
                </tr>
              
                `;
		}

		html += `
            </tbody>
        </table>`;
		return html;
	}

	private generateHtmlForForeignKeys(data: any, path: string): string {
		let html = `
    <h2>Foreign Keys Without Index</h2>
    <p>View the JSON data: <a href="${path}" download>View JSON</a></p>
    <table>
        <thead>
            <tr>
                <th>Table</th>
                <th>Column</th>
                <th>Size</th>
                <th>Constraint</th>
                <th>Referenced Table</th>
            </tr>
        </thead>
        <tbody>`;

		for (const item of data) {
			html += `
            <tr>
                <td>${item.table}</td>
                <td>${item.columns}</td>
                <td>${item.size}</td>
                <td>${item.constraint}</td>
                <td>${item.referenced_table}</td>
            </tr>`;
		}

		html += `
        </tbody>
    </table>`;
		return html;
	}

	private generateHtmlForSeqScans(data: any, path: string): string {
		let html = `
    <h2>Tables with Sequential Scans</h2>
    <p>View the JSON data: <a href="${path}" download>View JSON</a></p>
    <table>
        <thead>
            <tr>
                <th>Schema</th>
                <th>Table</th>
                <th>Seq Scan</th>
                <th>Seq Tup Read</th>
                <th>Index Scan</th>
                <th>Average</th>
            </tr>
        </thead>
        <tbody>`;

		for (const item of data) {
			html += `
            <tr>
                <td>${item.schemaname}</td>
                <td>${item.relname}</td>
                <td>${item.seq_scan}</td>
                <td>${item.seq_tup_read}</td>
                <td>${item.idx_scan}</td>
                <td>${item.avg}</td>
            </tr>`;
		}

		html += `
        </tbody>
    </table>`;
		return html;
	}

	private generateHtmlForLastVacuum(data: any, path: string): string {
		let html = `
    <h2>Tables with Last Vacuum/Analyze</h2>
    <p>View the JSON data: <a href="${path}" download>View JSON</a></p>
    <table>
        <thead>
            <tr>
                <th>Schema</th>
                <th>Table</th>
                <th>Last Vacuum</th>
                <th>Last Analyze</th>
                <th>Last AutoVacuum</th>
                <th>Last AutoAnalyze</th>
                <th>Live Tuples</th>
                <th>Dead Tuples</th>
            </tr>
        </thead>
        <tbody>`;

		for (const item of data) {
			html += `
            <tr>
                <td>${item.schemaname}</td>
                <td>${item.table_name}</td>
                <td>${item.last_vacuum ?? 'N/A'}</td>
                <td>${item.last_analyze ?? 'N/A'}</td>
                <td>${item.last_autovacuum ?? 'N/A'}</td>
                <td>${item.last_autoanalyze ?? 'N/A'}</td>
                <td>${item.n_live_tup}</td>
                <td>${item.n_dead_tup}</td>
            </tr>`;
		}

		html += `
        </tbody>
    </table>`;
		return html;
	}

	private generateHtmlForSlowQueries(data: any, path: string): string {
		let html = `
    <h2>Tables with Slow  Queries</h2>
    <p>View the JSON data: <a href="${path}" download>View JSON</a></p>
    <table>
        <thead>
            <tr>
                <th>queryId</th>
                <th>query</th>
                <th>total_exec_time</th>
                <th>calls</th>
                <th>mean_exec_time</th>
            </tr>
        </thead>
        <tbody>`;

		for (const item of data) {
			html += `
            <tr>
                <td>${item.queryId}</td>
                <td>${item.query}</td>
                <td>${item.total_exec_time}</td>
                <td>${item.calls}</td>
                <td>${item.mean_exec_time}</td>
            </tr>`;
		}

		html += `
        </tbody>
    </table>`;
		return html;
	}

	private generateHtmlForSlowAvgQueries(data: any, path: string): string {
		let html = `
    <h2>Tables with Slow  Average Queries</h2>
    <p>View the JSON data: <a href="${path}" download>View JSON</a></p>
    <table>
        <thead>
            <tr>
                <th>query</th>
                <th>total_time</th>
                <th>calls</th>
                <th>mean_time</th>
            </tr>
        </thead>
        <tbody>`;

		for (const item of data) {
			html += `
            <tr>
                <td>${item.query}</td>
                <td>${item.total_time}</td>
                <td>${item.calls}</td>
                <td>${item.mean_time}</td>
            </tr>`;
		}

		html += `
        </tbody>
    </table>`;
		return html;
	}

	private generateHtmlForUnUsedIndexesQueries(
		data: any,
		path: string
	): string {
		let html = `
    <h2>Tables with unused indexes</h2>
    <p>View the JSON data: <a href="${path}" download>View JSON</a></p>
    <table>
        <thead>
            <tr>
                <th>schemaname</th>
                <th>tablename</th>
                <th>calls</th>
                <th>index_size</th>
            </tr>
        </thead>
        <tbody>`;

		for (const item of data) {
			html += `
            <tr>
                <td>${item.schemaname}</td>
                <td>${item.tablename}</td>
                <td>${item.calls}</td>
                <td>${item.index_size}</td>
            </tr>`;
		}

		html += `
        </tbody>
    </table>`;
		return html;
	}
}
