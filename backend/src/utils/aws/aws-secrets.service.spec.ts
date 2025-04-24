import {
	SecretsManagerClient,
	GetSecretValueCommand,
	GetSecretValueCommandOutput
} from '@aws-sdk/client-secrets-manager';
import { AwsSecretsService } from './aws-secrets.service';
import * as fs from 'fs/promises';
import * as path from 'path';

jest.mock('@aws-sdk/client-secrets-manager');
jest.mock('fs/promises');
jest.mock('path');

describe('AwsSecretsService', () => {
	let service: AwsSecretsService;
	let mockSecretsManagerClient: jest.Mocked<SecretsManagerClient>;

	beforeEach(() => {
		mockSecretsManagerClient = {
			send: jest.fn()
		} as any;
		(SecretsManagerClient as jest.Mock).mockImplementation(
			() => mockSecretsManagerClient
		);

		service = new AwsSecretsService('us-east-1');
	});

	afterEach(() => {
		jest.clearAllMocks();
	});

	describe('fetchSecrets', () => {
		it('should fetch secrets successfully', async () => {
			const mockSecrets = { key1: 'value1', key2: 'value2' };
			const mockResponse: Partial<GetSecretValueCommandOutput> = {
				SecretString: JSON.stringify(mockSecrets)
			};
			(mockSecretsManagerClient.send as jest.Mock).mockResolvedValueOnce(
				mockResponse
			);

			const result = await service.fetchSecrets('test-secret-id');
			expect(result).toEqual(mockSecrets);
			expect(mockSecretsManagerClient.send).toHaveBeenCalledWith(
				expect.any(GetSecretValueCommand)
			);
		});

		it('should throw an error if SecretString is missing', async () => {
			const mockResponse: Partial<GetSecretValueCommandOutput> = {};
			(mockSecretsManagerClient.send as jest.Mock).mockResolvedValueOnce(
				mockResponse
			);

			await expect(
				service.fetchSecrets('test-secret-id')
			).rejects.toThrow('Secret is binary or missing');
		});

		it('should handle errors', async () => {
			(mockSecretsManagerClient.send as jest.Mock).mockRejectedValueOnce(
				new Error('Test error')
			);

			await expect(
				service.fetchSecrets('test-secret-id')
			).rejects.toThrow('Test error');
		});
	});

	describe('loadSecrets', () => {
		it('should load secrets into process.env', async () => {
			const mockSecrets = { KEY1: 'value1', KEY2: 'value2' };
			jest.spyOn(service, 'fetchSecrets').mockResolvedValueOnce(
				mockSecrets
			);

			await service.loadSecrets('test-secret-id');

			expect(process.env.KEY1).toBe('value1');
			expect(process.env.KEY2).toBe('value2');
		});

		it('should save secrets to file when saveToFile is true', async () => {
			const mockSecrets = { KEY1: 'value1', KEY2: 'value2' };
			jest.spyOn(service, 'fetchSecrets').mockResolvedValueOnce(
				mockSecrets
			);
			(path.resolve as jest.Mock).mockReturnValue('/mock/path/.env');
			(fs.readFile as jest.Mock).mockResolvedValueOnce('EXISTING=value');

			await service.loadSecrets('test-secret-id');

			expect(fs.writeFile).toHaveBeenCalledWith(
				'/mock/path/.env',
				'EXISTING=value\nKEY1=value1\nKEY2=value2'
			);
		});
	});

	describe('saveSecretsToFile', () => {
		it('should append secrets to existing .env file', async () => {
			const mockSecrets = { KEY1: 'value1', KEY2: 'value2' };
			(path.resolve as jest.Mock).mockReturnValue('/mock/path/.env');
			(fs.readFile as jest.Mock).mockResolvedValueOnce('EXISTING=value');

			await (service as any).saveSecretsToFile(mockSecrets);

			expect(fs.writeFile).toHaveBeenCalledWith(
				'/mock/path/.env',
				'EXISTING=value\nKEY1=value1\nKEY2=value2'
			);
		});

		it("should create new .env file if it doesn't exist", async () => {
			const mockSecrets = { KEY1: 'value1', KEY2: 'value2' };
			(path.resolve as jest.Mock).mockReturnValue('/mock/path/.env');
			(fs.readFile as jest.Mock).mockRejectedValueOnce({
				code: 'ENOENT'
			});

			await (service as any).saveSecretsToFile(mockSecrets);

			expect(fs.writeFile).toHaveBeenCalledWith(
				'/mock/path/.env',
				'KEY1=value1\nKEY2=value2'
			);
		});
	});
});
