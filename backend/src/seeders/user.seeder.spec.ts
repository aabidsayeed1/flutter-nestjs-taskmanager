import { Repository } from 'typeorm';
import { dataSource } from '../database/data-source';
import { User } from '../user/entities/user.entity';
import { seedUsers } from './user.seeder';

jest.mock('../database/data-source', () => ({
	dataSource: {
		initialize: jest.fn(),
		destroy: jest.fn(),
		getRepository: jest.fn()
	}
}));

describe('seedUsers', () => {
	let userRepository: jest.Mocked<Repository<User>>;

	beforeEach(() => {
		userRepository = {
			save: jest.fn()
		} as unknown as jest.Mocked<Repository<User>>;
	});

	afterEach(() => {
		jest.clearAllMocks();
	});

	it('should seed users successfully', async () => {
		(dataSource.initialize as jest.Mock).mockResolvedValueOnce(undefined);
		(dataSource.getRepository as jest.Mock).mockReturnValue(userRepository);
		/* 	userRepository.save.mockResolvedValueOnce(undefined); */
		(dataSource.destroy as jest.Mock).mockResolvedValueOnce(undefined);

		await seedUsers();

		expect(dataSource.initialize).toHaveBeenCalledTimes(2);
		expect(userRepository.save).toHaveBeenCalledTimes(1);
		expect(userRepository.save).toHaveBeenCalledWith([
			{
				name: 'John Doe',
				email: 'john@example.com',
				password: 'password123'
			},
			{
				name: 'Jane Doe',
				email: 'jane@example.com',
				password: 'password123'
			}
		]);
		expect(dataSource.destroy).toHaveBeenCalledTimes(2);
	});

	/* 	it('should handle errors during seeding', async () => {
		const error = new Error('Seeding error');
		(dataSource.initialize as jest.Mock).mockRejectedValueOnce(error);
		(dataSource.destroy as jest.Mock).mockResolvedValueOnce(undefined);
		userRepository.save.mockRejectedValueOnce(error);
		await expect(seedUsers()).rejects.toThrow('Seeding error');

		expect(dataSource.initialize).toHaveBeenCalledTimes(1);
		expect(dataSource.destroy).toHaveBeenCalledTimes(1);
	}); */

	/* it('should destroy the dataSource even if an error occurs', async () => {
		const error = new Error('Unexpected error');
		(dataSource.initialize as jest.Mock).mockResolvedValueOnce(undefined);
		userRepository.save.mockRejectedValueOnce(error);
		(dataSource.destroy as jest.Mock).mockResolvedValueOnce(undefined);

		await expect(seedUsers()).rejects.toThrow('Unexpected error');

		expect(dataSource.initialize).toHaveBeenCalledTimes(1);
		expect(userRepository.save).toHaveBeenCalledTimes(1);
		expect(dataSource.destroy).toHaveBeenCalledTimes(1);
	}); */
});

/* 
setup use in main db table
create subdomain
go to the superadmin portal

*/
