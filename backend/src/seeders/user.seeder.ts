import { dataSource } from '../database/data-source';
import { User } from '../user/entities/user.entity';

export const seedUsers = async () => {
	try {
		await dataSource.initialize();
		const userRepository = dataSource.getRepository(User);

		const users = [
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
		];

		await userRepository.save(users);
		console.log('Users seeded');
	} catch (error) {
		console.error('Error seeding users:', error);
		throw error;
	} finally {
		await dataSource.destroy();
	}
};

seedUsers().catch(error => {
	console.error('Error executing seed script:', error);
});
