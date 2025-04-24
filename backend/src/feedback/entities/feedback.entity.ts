import { BaseEntity } from '@/base/entities/base.entity';
import { User } from '@/user/entities/user.entity';
import { Entity, Column, ManyToOne } from 'typeorm';

export enum FeedbackType {
	FEEDBACK = 'FEEDBACK',
	FEATURE_SUGGESTION = 'FEATURE_SUGGESTION'
}

@Entity()
export class Feedback extends BaseEntity {
	@ManyToOne(() => User, user => user.feedback)
	user!: User;

	@Column({
		type: 'enum',
		enum: FeedbackType
	})
	type!: FeedbackType;

	@Column()
	message!: string;
}
