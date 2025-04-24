import { Module } from '@nestjs/common';
import { TypeOrmModule } from '@nestjs/typeorm';
import { Feedback } from './entities/feedback.entity';
import { FeedbackService } from './feedback.service';
import { FeedbackController } from './feedback.controller';
import { UserModule } from '@/user/user.module';
@Module({
	imports: [UserModule, TypeOrmModule.forFeature([Feedback])],
	providers: [FeedbackService],
	controllers: [FeedbackController],
	exports: [FeedbackService]
})
export class FeedbackModule {}
