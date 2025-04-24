import { IsWordLimit } from '@/base/validators/word-limit.validator';
import {
	IsEnum,
	IsNotEmpty,
	IsString,
	IsUUID,
	Validate
} from 'class-validator';
import { FeedbackType } from '../entities/feedback.entity';

export class CreateFeedbackDTO {
	@IsUUID()
	userId!: string;

	@IsNotEmpty()
	@IsEnum(FeedbackType)
	type!: FeedbackType;

	@Validate(IsWordLimit(100))
	@IsNotEmpty()
	@IsString()
	message!: string;
}
