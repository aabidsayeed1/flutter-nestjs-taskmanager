import { mockUser } from '@/factories/user.factory';
import { NotFoundException } from '@nestjs/common';
import { Test, TestingModule } from '@nestjs/testing';
import { JwtAuthGuard } from '../auth/guards/jwt-auth.guard';
import { UpdateUserDto } from './dto/update-user.dto';
import { UserController } from './user.controller';
import { UserService } from './user.service';

describe('UserController', () => {
	let controller: UserController;
	let userService: jest.Mocked<UserService>;

	beforeEach(async () => {
		const mockUserService = {
			findOne: jest.fn(),
			update: jest.fn(),
			remove: jest.fn()
		};

		const module: TestingModule = await Test.createTestingModule({
			controllers: [UserController],
			providers: [
				{
					provide: UserService,
					useValue: mockUserService
				}
			]
		})
			.overrideGuard(JwtAuthGuard)
			.useValue({ canActivate: () => true })
			.compile();

		controller = module.get<UserController>(UserController);
		userService = module.get(UserService);
	});

	it('should be defined', () => {
		expect(controller).toBeDefined();
	});

	describe('getProfile', () => {
		it('should return the user from the request', () => {
			const mockRequest = {
				user: mockUser
			} as any;

			expect(controller.getProfile(mockRequest)).toBe(mockUser);
		});
	});

	describe('getUserById', () => {
		it('should return a user if found', async () => {
			userService.findOne.mockResolvedValue(mockUser);

			const result = await controller.getUserById('1');
			expect(result).toEqual(mockUser);
			expect(userService.findOne).toHaveBeenCalledWith('1');
		});

		it('should throw NotFoundException if user is not found', async () => {
			userService.findOne.mockRejectedValue(
				new NotFoundException('User with ID 1 not found')
			);

			await expect(controller.getUserById('1')).rejects.toThrow(
				NotFoundException
			);
			expect(userService.findOne).toHaveBeenCalledWith('1');
		});
	});
	describe('deleteUserById', () => {
		it('should call userService.remove with the correct ID and return NO_CONTENT status', async () => {
			const userId = '1';
			const removeSpy = jest
				.spyOn(userService, 'remove')
				.mockResolvedValueOnce(undefined);
			const response = await controller.deleteUser(userId);
			expect(removeSpy).toHaveBeenCalledWith(userId);
			expect(response).toBeUndefined();
		});
	});

	describe('updateProfile', () => {
		it('should update user profile successfully', async () => {
			const userId = '1';
			const updateUserDto: UpdateUserDto = {
				name: 'New Name',
				profilePicture: 'new-picture.jpg'
			};
			const updatedUser = {
				id: '1',
				name: 'New Name',
				profilePicture: 'new-picture.jpg',
				email: 'user@example.com',
				password: 'hashedpassword',
				isVerified: false,
				verificationToken: null,
				resetPasswordToken: null,
				resetPasswordExpires: null,
				deletedAt: null,
				updatedAt: new Date(),
				createdAt: new Date()
			};
			userService.update.mockResolvedValue(updatedUser as any);

			const result = await controller.updateProfile(
				userId,
				updateUserDto
			);

			expect(userService.update).toHaveBeenCalledWith(
				userId,
				updateUserDto
			);
			expect(result).toEqual(updatedUser);
		});

		it('should throw NotFoundException if user not found', async () => {
			const userId = '1';
			const updateUserDto: UpdateUserDto = {
				name: 'New Name',
				profilePicture: 'new-picture.jpg'
			};

			userService.update.mockRejectedValue(
				new NotFoundException('User not found')
			);

			await expect(
				controller.updateProfile(userId, updateUserDto)
			).rejects.toThrow(NotFoundException);
			expect(userService.update).toHaveBeenCalledWith(
				userId,
				updateUserDto
			);
		});
	});
});
