import { mockFeedback, mockFeedbackGroup } from '@/factories/feedback.factory';
import { User } from '@/user/entities/user.entity';
import { UserService } from '@/user/user.service';
import { BadRequestException, NotFoundException } from '@nestjs/common';
import { Test, TestingModule } from '@nestjs/testing';
import { getRepositoryToken } from '@nestjs/typeorm';
import { Repository } from 'typeorm';
import { Feedback } from './entities/feedback.entity';
import { FeedbackService } from './feedback.service';

describe('FeedbackService', () => {
	let service: FeedbackService;
	let feedbackRepository: Repository<Feedback>;
	let userService: UserService;
	beforeEach(async () => {
		const mockUserService = {
			findOne: jest.fn().mockResolvedValue(mockFeedback.user)
		};
		const mockFeedbackRepository = {
			save: jest.fn().mockResolvedValue(mockFeedback), // Mock save method
			find: jest.fn().mockResolvedValue([mockFeedback]),
			findOne: jest.fn().mockResolvedValue(mockFeedback),
			create: jest.fn().mockReturnValue(mockFeedback)
		};
		const module: TestingModule = await Test.createTestingModule({
			providers: [
				FeedbackService,
				{
					provide: getRepositoryToken(Feedback),
					useValue: mockFeedbackRepository
				},
				{
					provide: UserService,
					useValue: mockUserService
				}
			]
		}).compile();

		service = module.get<FeedbackService>(FeedbackService);
		feedbackRepository = module.get<Repository<Feedback>>(
			getRepositoryToken(Feedback)
		);
		userService = module.get<UserService>(UserService);
		await feedbackRepository.save(mockFeedback);
	});

	it('should be defined', () => {
		expect(service).toBeDefined();
	});

	describe('createFeedback', () => {
		it('should create and save feedback', async () => {
			const { user, type: feedbackType, message } = mockFeedback;
			const userId = user.id;

			jest.spyOn(userService, 'findOne').mockResolvedValue(user as User); // Mock userService to return mock user
			jest.spyOn(feedbackRepository, 'create').mockReturnValue(
				mockFeedback as any
			);
			jest.spyOn(feedbackRepository, 'save').mockResolvedValue(
				mockFeedback as any
			); // Mock feedback saving

			await service.createFeedback(userId, feedbackType, message);

			expect(userService.findOne).toHaveBeenCalledWith(userId);

			expect(feedbackRepository.create).toHaveBeenCalledWith({
				user,
				type: feedbackType,
				message
			});

			expect(feedbackRepository.save).toHaveBeenCalledWith(mockFeedback);
		});
	});

	describe('findAll Feedbacks', () => {
		it('should return all feedback with user details excluding password', async () => {
			const result = await service.findAll();
			console.log('result =', JSON.stringify(result, null, 2));

			expect(result).toHaveLength(1);
			expect(result[0]?.feedbacks[0]?.id).toEqual(
				mockFeedbackGroup[0]?.feedbacks[0]?.id
			);
			expect(result[0]?.feedbacks[0]?.message).toEqual(
				mockFeedbackGroup[0]?.feedbacks[0]?.message
			);
			expect(result[0]?.user?.id).toEqual(mockFeedbackGroup[0]?.user?.id);
		});
	});

	describe('findByUser', () => {
		it('should throw BadRequestException if userId is not a UUID ', async () => {
			const invalidUserId = 'invalid-uuid';
			jest.spyOn(feedbackRepository, 'find').mockResolvedValue(
				undefined as any
			);
			await expect(service.findByUser(invalidUserId)).rejects.toThrow(
				new BadRequestException('Invalid userId: must be a valid UUID')
			);
			expect(userService.findOne).not.toHaveBeenCalled();
			expect(feedbackRepository.find).not.toHaveBeenCalled();
		});

		it('should return all feedback for a specific user with user details excluding password', async () => {
			const result = await service.findByUser(mockFeedback.user.id);
			console.log('result =', result);
			console.log('mockfeedback=', mockFeedbackGroup[0]);
			expect(userService.findOne).toHaveBeenCalledWith(
				mockFeedback.user.id
			);
			expect(feedbackRepository.find).toHaveBeenCalledWith({
				where: { user: { id: mockFeedback.user.id } },
				relations: ['user'],
				order: { createdAt: 'DESC' }
			});
			expect(result).toEqual(mockFeedbackGroup[0]);
		});
	});

	describe('findByID', () => {
		it('should throw BadRequestException if feedbackId is not a valid UUID', async () => {
			const invalidFeedbackId = 'invalid-uuid';

			await expect(service.findById(invalidFeedbackId)).rejects.toThrow(
				BadRequestException
			);
		});

		it('should throw NotFoundException if feedback with the given ID is not found', async () => {
			const feedbackId = '6c53bfe3-1c2d-4e45-9406-7337159c8c02';

			jest.spyOn(feedbackRepository, 'findOne').mockResolvedValue(null);

			await expect(service.findById(feedbackId)).rejects.toThrow(
				NotFoundException
			);
		});

		it('should return feedback with user details if found', async () => {
			const result = await service.findById(mockFeedback.id);
			expect(result).toEqual(mockFeedback);
		});
	});
});
