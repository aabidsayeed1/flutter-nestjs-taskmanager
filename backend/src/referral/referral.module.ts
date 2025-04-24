import { Module } from '@nestjs/common';
import { ReferralController } from './referral.controller';
import { ReferralService } from './referral.service';
import { UserModule } from '@/user/user.module';
import { JwtAuthGuard } from '@/auth/guards/jwt-auth.guard';
import { JwtStrategy } from '@/auth/strategy/jwt-auth.strategy';
import { TypeOrmModule } from '@nestjs/typeorm';
import { Referral } from './entities/referral.entity';
import { ReferralUsage } from './entities/referral-usage.entity';
import { ReferralReward } from './entities/referral-reward.entity';

@Module({
	imports: [
		UserModule,
		TypeOrmModule.forFeature([Referral, ReferralUsage, ReferralReward])
	],
	controllers: [ReferralController],
	providers: [ReferralService, JwtStrategy, JwtAuthGuard]
})
export class ReferralModule {}
