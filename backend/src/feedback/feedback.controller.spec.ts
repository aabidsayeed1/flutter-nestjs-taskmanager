import { Test, TestingModule } from '@nestjs/testing';
import { FeedbackController } from './feedback.controller';
import { FeedbackService } from './feedback.service';
import { CreateFeedbackDTO } from './dtos/create-feedback.dto';
import { FeedbackType } from './entities/feedback.entity';
import { BadRequestException, NotFoundException } from '@nestjs/common';

describe('FeedbackController', () => {
	let controller: FeedbackController;
	let feedbackService: FeedbackService;

	beforeEach(async () => {
		const mockFeedbackService = {
			createFeedback: jest.fn(),
			findByUser: jest.fn(),
			findAll: jest.fn(),
			findById: jest.fn()
		};

		const module: TestingModule = await Test.createTestingModule({
			controllers: [FeedbackController],
			providers: [
				{ provide: FeedbackService, useValue: mockFeedbackService }
			]
		}).compile();

		controller = module.get<FeedbackController>(FeedbackController);
		feedbackService = module.get<FeedbackService>(FeedbackService);
	});

	it('should be defined', () => {
		expect(controller).toBeDefined();
	});

	describe('createFeedback', () => {
		it('should call feedbackService.createFeedback with the correct data', async () => {
			const dto: CreateFeedbackDTO = {
				userId: 'valid-uuid',
				type: FeedbackType.FEEDBACK,
				message: 'Awesome feature!'
			};

			await controller.createFeedback(dto);
			expect(feedbackService.createFeedback).toHaveBeenCalledWith(
				dto.userId,
				dto.type,
				dto.message
			);
		});
	});

	describe('getFeedbackByUser', () => {
		it('should call feedbackService.findByUser with the correct userId', async () => {
			const userId = 'user-id-1';
			const feedbacks = [
				{
					id: 'feedback-id-1',
					message: 'Awesome feature!',
					user: {
						id: 'user-id-1',
						name: 'Abid',
						email: 'abid.syeed@napses.com'
					},
					type: FeedbackType.FEEDBACK,
					createdAt: new Date(),
					updatedAt: new Date(),
					deletedAt: null
				}
			];
			jest.spyOn(feedbackService, 'findByUser').mockResolvedValue(
				feedbacks as any
			);

			const result = await controller.getFeedbackByUser(userId);
			expect(feedbackService.findByUser).toHaveBeenCalledWith(userId);
			expect(result).toEqual(feedbacks);
		});
	});

	describe('getAllFeedback', () => {
		it('should call feedbackService.findAll and return all feedbacks', async () => {
			const feedbacks = [
				{
					id: 'feedback-id-1',
					message: 'Awesome feature!',
					user: {
						id: 'user-id-1',
						name: 'Abid',
						email: 'abid.syeed@napses.com'
					},
					type: FeedbackType.FEEDBACK,
					createdAt: new Date(),
					updatedAt: new Date(),
					deletedAt: null
				},
				{
					id: 'feedback-id-2',
					message: 'Needs improvement!',
					user: {
						id: 'user-id-2',
						name: 'Satish',
						email: 'satish@napses.com'
					},
					type: FeedbackType.FEATURE_SUGGESTION,
					createdAt: new Date(),
					updatedAt: new Date(),
					deletedAt: null
				}
			];
			jest.spyOn(feedbackService, 'findAll').mockResolvedValue(feedbacks);

			const result = await controller.getAllFeedback();
			expect(feedbackService.findAll).toHaveBeenCalled();
			expect(result).toEqual(feedbacks);
		});
	});

	describe('getFeedbackById', () => {
		it('should throw BadRequestException if feedbackId is not a valid UUID', async () => {
			const feedbackId = 'invalid-uuid';

			jest.spyOn(feedbackService, 'findById').mockRejectedValue(
				new BadRequestException(
					'Invalid feedbackId: must be a valid UUID'
				)
			);

			await expect(
				controller.getFeedbackById(feedbackId)
			).rejects.toThrow(BadRequestException);
		});
		it('should throw NotFoundException if feedback with the given ID is not found', async () => {
			const feedbackId = '6c53bfe3-1c2d-4e45-9406-7337159c8c02';

			jest.spyOn(feedbackService, 'findById').mockRejectedValue(
				new NotFoundException(
					`Feedback with ID ${feedbackId} not found`
				)
			);

			await expect(
				controller.getFeedbackById(feedbackId)
			).rejects.toThrow(NotFoundException);
		});
	});
	it('should return feedback if it is found', async () => {
		const feedbackId = '6c53bfe3-1c2d-4e45-9406-7337159c8c02';
		const feedback = {
			id: feedbackId,
			type: 'General',
			message: 'Test feedback',
			createdAt: new Date(),
			updatedAt: new Date(),
			deletedAt: null,
			user: {
				id: '1b2e4f9e-44e1-4b3e-9874-2d7622c0cbd8',
				name: 'abid',
				email: 'abid.syeed@napses.com'
			}
		};

		jest.spyOn(feedbackService, 'findById').mockResolvedValue(
			feedback as any
		);

		const result = await controller.getFeedbackById(feedbackId);

		expect(result).toEqual(feedback);
	});
});
