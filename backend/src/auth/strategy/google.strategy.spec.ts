import { ConfigModule } from '@nestjs/config';
import { Test, TestingModule } from '@nestjs/testing';
import { GoogleStrategy } from './google.strategy';

describe('GoogleStrategy', () => {
	let strategy: GoogleStrategy;

	beforeEach(async () => {
		// Set up environment variables for testing
		process.env.GOOGLE_CLIENT_ID = 'test-google-client-id';
		process.env.GOOGLE_CLIENT_SECRET = 'test-google-client-secret';
		process.env.API_HOST = 'http://localhost:3000';
		process.env.GOOGLE_AUTH_REDIRECT_CALLBACK = '/auth/redirect';

		// Create the testing module and include necessary imports and providers
		const module: TestingModule = await Test.createTestingModule({
			imports: [ConfigModule.forRoot()],
			providers: [GoogleStrategy]
		}).compile();

		// Retrieve the GoogleStrategy instance from the testing module
		strategy = module.get<GoogleStrategy>(GoogleStrategy);
	});

	it('should be defined', () => {
		expect(strategy).toBeDefined();
	});

	describe('validate', () => {
		it('should correctly validate and return the user object', async () => {
			// Mock data for testing the validate method
			const accessToken = 'test-access-token';
			const refreshToken = 'test-refresh-token';
			const profile = {
				name: {
					givenName: 'John',
					familyName: 'Doe'
				},
				emails: [{ value: 'john.doe@example.com' }],
				photos: [{ value: 'http://example.com/photo.jpg' }]
			};

			// Create a mock for the done callback
			const done = jest.fn();

			// Call the validate method with the mock data
			await strategy.validate(accessToken, refreshToken, profile, done);

			// Assert that the done callback was called with the correct user object
			expect(done).toHaveBeenCalledWith(null, {
				email: 'john.doe@example.com',
				firstName: 'John',
				lastName: 'Doe',
				picture: 'http://example.com/photo.jpg',
				accessToken: 'test-access-token'
			});
		});

		it('should handle profiles with missing emails gracefully', async () => {
			const accessToken = 'test-access-token';
			const refreshToken = 'test-refresh-token';
			const profile = {
				name: {
					givenName: 'Jane',
					familyName: 'Smith'
				},
				emails: [],
				photos: [{ value: 'http://example.com/photo.jpg' }]
			};

			const done = jest.fn();

			await strategy.validate(accessToken, refreshToken, profile, done);
			expect(done).toHaveBeenCalledWith(null, {
				email: undefined,
				firstName: 'Jane',
				lastName: 'Smith',
				picture: 'http://example.com/photo.jpg',
				accessToken: 'test-access-token'
			});
		});

		it('should handle profiles with missing photos gracefully', async () => {
			const accessToken = 'test-access-token';
			const refreshToken = 'test-refresh-token';
			const profile = {
				name: {
					givenName: 'Alice',
					familyName: 'Johnson'
				},
				emails: [{ value: 'alice.johnson@example.com' }],
				photos: []
			};

			const done = jest.fn();

			await strategy.validate(accessToken, refreshToken, profile, done);

			expect(done).toHaveBeenCalledWith(null, {
				email: 'alice.johnson@example.com',
				firstName: 'Alice',
				lastName: 'Johnson',
				picture: undefined,
				accessToken: 'test-access-token'
			});
		});
	});
});
