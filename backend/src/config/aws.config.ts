import { registerAs } from '@nestjs/config';

export default registerAs('aws', () => ({
	s3: {
		bucket: process.env.AWS_S3_BUCKET || '',
		accessKeyId: process.env.AWS_S3_ACCESS_KEY_ID || '',
		secretKey: process.env.AWS_S3_SECRET_KEY || '',
		region: process.env.AWS_S3_REGION || ''
	},
	cloudwatch: {
		logGroupName: process.env.AWS_LOG_GROUP_NAME || '',
		logStreamName: process.env.AWS_LOG_STREAM_NAME || '',
		accessKeyId: process.env.AWS_LOG_ACCESS_KEY_ID || '',
		secretKey: process.env.AWS_LOG_SECRET_KEY || '',
		region: process.env.AWS_LOG_REGION || ''
	},
	cognito: {
		userPoolId: process.env.AWS_COGNITO_USER_POOL_ID || '',
		clientId: process.env.AWS_COGNITO_CLIENT_ID || '',
		region: process.env.AWS_COGNITO_REGION || ''
	},
	sqs: {
		queueUrl: process.env.AWS_SQS_QUEUE_URL || '',
		accessKeyId: process.env.AWS_SQS_ACCESS_KEY_ID || '',
		secretKey: process.env.AWS_SQS_SECRET_KEY || '',
		region: process.env.AWS_SQS_REGION || ''
	}
}));
