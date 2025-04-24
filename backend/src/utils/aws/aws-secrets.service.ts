import {
	GetSecretValueCommand,
	SecretsManagerClient
} from '@aws-sdk/client-secrets-manager';
import { fromNodeProviderChain } from '@aws-sdk/credential-providers';
import { config } from 'dotenv';
import * as fs from 'fs/promises';
import * as path from 'path';

// Load environment variables from .env file
config();

export class AwsSecretsService {
	private client: SecretsManagerClient;

	constructor(
		private region: string = process.env.AWS_SM_REGION || 'us-east-1'
	) {
		const awsConfig: any = {
			region: this.region,
			credentials: fromNodeProviderChain()
		};

		if (
			process.env.AWS_SM_ACCESS_KEY_ID &&
			process.env.AWS_SM_SECRET_ACCESS_KEY_ID
		) {
			awsConfig.credentials = {
				accessKeyId: process.env.AWS_SM_ACCESS_KEY_ID,
				secretAccessKey: process.env.AWS_SM_SECRET_ACCESS_KEY_ID
			};
		}

		if (process.env.AWS_ENDPOINT) {
			awsConfig.endpoint = process.env.AWS_ENDPOINT;
		}
		this.client = new SecretsManagerClient(awsConfig);
	}

	async fetchSecrets(secretId: string): Promise<Record<string, string>> {
		try {
			const command = new GetSecretValueCommand({ SecretId: secretId });
			const response = await this.client.send(command);

			if (!response.SecretString) {
				throw new Error('Secret is binary or missing');
			}

			return JSON.parse(response.SecretString);
		} catch (error) {
			if (error instanceof Error) {
				//console.error('Error fetching secrets:', error.message);
			} else {
				//console.error('Unknown error fetching secrets:', error);
			}
			throw error;
		}
	}

	async loadSecrets(secretId: string): Promise<void> {
		const secrets = await this.fetchSecrets(secretId);

		// Load secrets into process.env
		Object.entries(secrets).forEach(([key, value]) => {
			process.env[key] = value;
		});

		console.log('Secrets file loaded');
		await this.saveSecretsToFile(secrets);
	}

	private async saveSecretsToFile(
		secrets: Record<string, string>
	): Promise<void> {
		const envFilePath = path.resolve('.env');
		const envContent = Object.entries(secrets)
			.map(([key, value]) => `${key}=${value}`)
			.join('\n');

		let existingContent = '';
		try {
			existingContent = await fs.readFile(envFilePath, 'utf-8');
		} catch (err) {
			if ((err as NodeJS.ErrnoException).code !== 'ENOENT') {
				throw err;
			}
		}

		const newContent = existingContent
			? `${existingContent}\n${envContent}`
			: envContent;

		await fs.writeFile(envFilePath, newContent);
	}
}
