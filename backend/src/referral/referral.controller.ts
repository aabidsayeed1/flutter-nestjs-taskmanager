import { JwtAuthGuard } from '@/auth/guards/jwt-auth.guard';
import { UserPayload } from '@/user/payloads/user.payload';
import { Response } from '@/utils/response/decorators/response.decorator';
import {
	Body,
	Controller,
	Get,
	Param,
	Post,
	Req,
	UnauthorizedException,
	UseGuards
} from '@nestjs/common';
import { Request } from 'express';
import { ReferralService } from './referral.service';
@Controller('referrals')
@Response('success')
export class ReferralController {
	constructor(private readonly referralService: ReferralService) {}

	@Post('generate')
	@UseGuards(JwtAuthGuard)
	async generateReferralCode(@Req() request: Request) {
		const user = request.user as UserPayload;
		if (!user) {
			throw new UnauthorizedException('User not found');
		}
		const userId = user.userId;
		return await this.referralService.generateReferralCode(userId);
	}

	@Get(':userId')
	async getMyReferralCode(@Param('userId') userId: string) {
		return await this.referralService.getReferralCodeByUserId(userId);
	}

	@Get('validate/:code')
	async validateReferralCode(@Param('code') code: string) {
		return this.referralService.validateReferralCode(code);
	}
	@Post('signup')
	async handleNewUserSignup(
		@Body('userId') userId: string,
		@Body('referralCode') referralCode: string
	): Promise<void> {
		await this.referralService.handleNewUserSignup(userId, referralCode);
	}

	@Get('rewards/:userId')
	async getUserReferralRewards(@Param('userId') userId: string) {
		return this.referralService.getReferralRewards(userId);
	}
	@Get('usage/:referralId/users')
	async getReferralUsageByReferral(@Param('referralId') referralId: string) {
		return await this.referralService.getReferralUsageByReferralId(
			referralId
		);
	}
}
