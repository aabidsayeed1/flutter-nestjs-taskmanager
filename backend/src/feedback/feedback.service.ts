import { UserService } from '@/user/user.service';
import {
	BadRequestException,
	Injectable,
	NotFoundException
} from '@nestjs/common';
import { InjectRepository } from '@nestjs/typeorm';
import { isUUID } from 'class-validator';
import { Repository } from 'typeorm';
import { Feedback, FeedbackType } from './entities/feedback.entity';

@Injectable()
export class FeedbackService {
	constructor(
		@InjectRepository(Feedback)
		private feedbackRepository: Repository<Feedback>,
		private userService: UserService
	) {}

	async createFeedback(userId: string, type: FeedbackType, message: string) {
		const user = await this.userService.findOne(userId);
		const feedback = this.feedbackRepository.create({
			user,
			type,
			message
		});
		this.feedbackRepository.save(feedback);
	}

	async findAll() {
		const feedbacks = await this.feedbackRepository.find({
			relations: ['user'],
			order: { createdAt: 'DESC' }
		});
		const groupedByUser = feedbacks.reduce(
			(acc: Record<string, any>, feedback) => {
				const { id, name, email } = feedback.user;

				if (!acc[id]) {
					acc[id] = {
						user: { id, name, email },
						feedbacks: []
					};
				}

				acc[id].feedbacks.push({
					id: feedback.id,
					type: feedback.type,
					message: feedback.message,
					createdAt: feedback.createdAt,
					updatedAt: feedback.updatedAt,
					deletedAt: feedback.deletedAt
				});

				return acc;
			},
			{}
		);
		return Object.values(groupedByUser);
	}

	async findByUser(userId: string) {
		if (!isUUID(userId)) {
			throw new BadRequestException(
				'Invalid userId: must be a valid UUID'
			);
		}
		const user = await this.userService.findOne(userId);
		const feedbacks = await this.feedbackRepository.find({
			where: { user: { id: userId } },
			relations: ['user'],
			order: { createdAt: 'DESC' }
		});
		const { id, name, email } = user;
		return {
			user: { id, name, email },
			feedbacks: feedbacks.map(item => {
				// eslint-disable-next-line @typescript-eslint/no-unused-vars
				const { user, ...feedbackWithoutUser } = item;
				return feedbackWithoutUser;
			})
		};
	}
	async findById(feedbackId: string) {
		if (!isUUID(feedbackId)) {
			throw new BadRequestException(
				'Invalid feedbackId: must be a valid UUID'
			);
		}
		const feedback = await this.feedbackRepository.findOne({
			where: { id: feedbackId },
			relations: ['user']
		});

		if (!feedback) {
			throw new NotFoundException(
				`Feedback with ID ${feedbackId} not found`
			);
		}
		const { id, name, email } = feedback.user;

		return {
			...feedback,
			user: { id, name, email }
		};
	}
}
