//import AppDataSource from '@/config/test-setup';
import { dataSource } from '@/database/data-source';
import { mockUser } from '@/factories/user.factory';
import { I18nHelperService } from '@/i18n-helper/i18n-helper.service';
import { mockI18nHelperService } from '@/utils/test-utils';
import { NotFoundException } from '@nestjs/common';
import { Test, TestingModule } from '@nestjs/testing';
import { getRepositoryToken } from '@nestjs/typeorm';
import { Repository } from 'typeorm';
import { UpdateUserDto } from './dto/update-user.dto';
import { User } from './entities/user.entity';
import { UserService } from './user.service';

describe('UserService', () => {
	let service: UserService;
	let userRepository: Repository<User>;
	//let mockUser: User;

	beforeAll(async () => {
		await dataSource.initialize();
	});

	afterAll(async () => {
		await dataSource.destroy();
	});

	beforeEach(async () => {
		const module: TestingModule = await Test.createTestingModule({
			providers: [
				UserService,
				{
					provide: getRepositoryToken(User),
					useValue: dataSource.getRepository(User)
				},
				{
					provide: I18nHelperService,
					useValue: mockI18nHelperService
				}
			]
		}).compile();

		service = module.get<UserService>(UserService);
		userRepository = module.get<Repository<User>>(getRepositoryToken(User));

		await userRepository.save(mockUser);
	});

	afterEach(async () => {
		//await userRepository.query('DELETE FROM users');
		await dataSource.transaction(async transactionalEntityManager => {
			await transactionalEntityManager.delete(User, {});
		});
	});

	it('should be defined', () => {
		expect(service).toBeDefined();
	});

	describe('create', () => {
		it('should successfully create a user', async () => {
			const createUserDto = {
				name: 'New User',
				email: 'new@example.com',
				password: 'password123'
			};

			const result = await service.create(createUserDto);
			const savedUser = await userRepository.findOneBy({
				email: createUserDto.email
			});

			expect(result).toBeDefined();
			expect(savedUser).toBeDefined();
			expect(savedUser?.name).toBe(createUserDto.name);
		});
	});

	describe('findAll', () => {
		it('should return an array of users', async () => {
			const result = await service.findAll();
			expect(result[0]?.id).toEqual(mockUser?.id);
		});
	});

	describe('findOne', () => {
		it('should return a user if found', async () => {
			const result = await service.findOne(mockUser.id);
			expect(result?.id).toEqual(mockUser?.id);
		});

		it('should throw NotFoundException if user is not found', async () => {
			await expect(
				service.findOne('0191b843-8520-725a-ad85-c4e52783bfda')
			).rejects.toThrow(NotFoundException);
		});
	});

	describe('findByEmail', () => {
		it('should return a user if found', async () => {
			const result = await service.findByEmail(mockUser.email);
			expect(result?.id).toEqual(mockUser?.id);
		});

		it('should return null if user is not found', async () => {
			const result = await service.findByEmail('nonexistent@example.com');
			expect(result).toBeNull();
		});
	});

	describe('findByVerificationToken', () => {
		it('should return a user if found', async () => {
			const result = await service.findByVerificationToken(
				mockUser.verificationToken!
			);
			expect(result?.id).toEqual(mockUser?.id);
		});
	});

	describe('findByResetPasswordToken', () => {
		it('should return a user if found', async () => {
			const result = await service.findByResetPasswordToken(
				mockUser.resetPasswordToken!
			);
			expect(result?.id).toEqual(mockUser.id);
		});
	});

	describe('save', () => {
		it('should save and return the user', async () => {
			mockUser.name = 'Updated Name';
			const result = await service.save(mockUser);
			const updatedUser = await userRepository.findOneBy({
				id: mockUser.id
			});
			expect(result.id).toEqual(updatedUser?.id);
			expect(updatedUser?.name).toBe('Updated Name');
		});
	});

	describe('update', () => {
		it('should update the user successfully', async () => {
			const userId = mockUser.id;
			const updateUserDto: UpdateUserDto = {
				name: 'Updated Name',
				profilePicture: 'updated-picture.jpg'
			};

			const result = await service.update(userId, updateUserDto);
			const updatedUser = await userRepository.findOneBy({ id: userId });

			expect(updatedUser?.name).toBe(updateUserDto.name);
			expect(updatedUser?.profilePicture).toBe(
				updateUserDto.profilePicture
			);
			expect(result).toEqual(updatedUser);
		});

		it('should throw NotFoundException if user not found', async () => {
			const userId = '0191b843-8520-725a-ad85-c4e52783bfda';
			const updateUserDto: UpdateUserDto = {
				name: 'Updated Name',
				profilePicture: 'updated-picture.jpg'
			};

			await expect(service.update(userId, updateUserDto)).rejects.toThrow(
				NotFoundException
			);
		});
	});

	describe('remove', () => {
		it('should set deletedAt field for an existing user', async () => {
			const userId = mockUser.id;

			await service.remove(userId);
			const deletedUser = await userRepository.query(
				`SELECT * FROM users WHERE id = $1`,
				[userId]
			);
			expect(deletedUser[0]?.deletedAt).toBeInstanceOf(Date);
		});

		it('should throw NotFoundException if user is not found', async () => {
			const userId = '0191b843-8520-725a-ad85-c4e52783bfda';
			await expect(service.remove(userId)).rejects.toThrow(
				NotFoundException
			);
		});
	});

	describe('updateRefreshToken', () => {
		it('should update refresh token successfully', async () => {
			const userId = mockUser.id;
			const refreshToken = 'test-update-refresh-token';

			await service.updateRefreshToken(userId, refreshToken);

			const savedUser = await userRepository.findOneBy({
				id: userId
			});

			expect(savedUser).toBeDefined();
			expect(savedUser?.refreshToken).not.toBe(refreshToken);
			expect(savedUser?.id).toBe(userId);
		});
	});

	describe('clearRefreshToken', () => {
		it('should clear refresh token successfully', async () => {
			const userId = mockUser.id;
			await service.clearRefreshToken(userId);
			const savedUser = await userRepository.findOneBy({
				id: userId
			});

			expect(savedUser).toBeDefined();
			expect(savedUser?.refreshToken).toBe(null);
		});
	});
});
