import {config} from 'dotenv' 
import { AwsSecretsService } from '../src/utils/aws/aws-secrets.service';

config()

async function loadSecrets() {
  const secretId = process.env.AWS_SM_SECRET_ID;
  
  if (!secretId) {
    console.error('AWS_SECRET_ID is not set');
    process.exit(1);
  }

  const awsSecretsService = new AwsSecretsService();

  try {
    await awsSecretsService.loadSecrets(secretId);
    console.log('Secrets loaded successfully');
  } catch (error) {
    console.error('Failed to load secrets:', error);
    process.exit(1);
  }
}

loadSecrets();