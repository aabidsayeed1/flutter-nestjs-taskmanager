import { Controller, Post, Body, Get, Param } from '@nestjs/common';
import { FeedbackService } from './feedback.service';
import { CreateFeedbackDTO } from './dtos/create-feedback.dto';
import { Response } from '@/utils/response/decorators/response.decorator';

@Controller('feedback')
@Response('success')
export class FeedbackController {
	constructor(private readonly feedbackService: FeedbackService) {}
	@Post()
	async createFeedback(@Body() createFeedbackDTO: CreateFeedbackDTO) {
		const { userId, type, message } = createFeedbackDTO;
		this.feedbackService.createFeedback(userId, type, message);
	}

	@Get('user/:userId')
	async getFeedbackByUser(@Param('userId') userId: string) {
		return this.feedbackService.findByUser(userId);
	}
	@Get(':feedbackId')
	async getFeedbackById(@Param('feedbackId') feedbackId: string) {
		return this.feedbackService.findById(feedbackId);
	}

	@Get()
	async getAllFeedback() {
		return this.feedbackService.findAll();
	}
}
