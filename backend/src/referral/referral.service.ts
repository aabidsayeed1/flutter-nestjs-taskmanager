import { User } from '@/user/entities/user.entity';
import { UserService } from '@/user/user.service';
import {
	ConflictException,
	Injectable,
	NotFoundException
} from '@nestjs/common';
import { ConfigService } from '@nestjs/config';
import { InjectRepository } from '@nestjs/typeorm';
import * as shortid from 'shortid';
import { Repository } from 'typeorm';
import { ReferralReward } from './entities/referral-reward.entity';
import { ReferralUsage } from './entities/referral-usage.entity';
import { Referral } from './entities/referral.entity';

@Injectable()
export class ReferralService {
	constructor(
		@InjectRepository(Referral)
		private referralRepository: Repository<Referral>,
		@InjectRepository(ReferralUsage)
		private referralUsageRepository: Repository<ReferralUsage>,
		@InjectRepository(ReferralReward)
		private rewardRepository: Repository<ReferralReward>,
		private userService: UserService,
		private readonly configService: ConfigService
	) {}

	async generateReferralCode(userId: string) {
		const user = await this.userService.findOne(userId);
		let referral = await this.referralRepository.findOne({
			where: { user: { id: userId } }
		});
		if (!referral) {
			const code = this.createUniqueReferralCode();
			referral = await this.saveReferralCode(user, code);
		}
		return await this.validateReferralCode(referral.code);
	}

	async getReferralCodeByUserId(userId: string) {
		await this.userService.findOne(userId);
		const referral = await this.referralRepository.findOne({
			where: { user: { id: userId } }
		});
		if (!referral) {
			throw new NotFoundException('Referral code not found');
		}
		return await this.validateReferralCode(referral.code);
	}

	async getReferralRewards(userId: string): Promise<any> {
		const referralReward = await this.rewardRepository.findOne({
			where: { user: { id: userId } }
		});

		return referralReward
			? {
					reward: referralReward.reward,
					currentExpiryDate:
						referralReward.rewardsExpiry?.toISOString()
				}
			: null;
	}

	async getReferralUsageByReferralId(referralId: string) {
		const referral = await this.referralRepository.findOne({
			where: { id: referralId },
			relations: ['referralUsages']
		});

		if (!referral) {
			throw new NotFoundException(
				`Referral with ID ${referralId} not found`
			);
		}
		const referralUsages = await this.referralUsageRepository.find({
			where: { referral: { id: referralId } },
			relations: ['user']
		});

		const users = referralUsages.map(referralUsage => ({
			id: referralUsage.user.id,
			name: referralUsage.user.name,
			email: referralUsage.user.email
		}));
		return {
			referral: {
				referralId: referral.id,
				referralCode: referral.code
			},
			users: users
		};
	}

	async validateReferralCode(code: string) {
		const referral = await this.referralRepository.findOne({
			where: { code },
			relations: ['user', 'referredUsers']
		});
		if (!referral) {
			throw new NotFoundException('Referral code not found');
		}
		const { id, name, email } = referral.user;
		const referredUsers = referral.referredUsers.map(user => ({
			id: user.id,
			name: user.name,
			email: user.email
		}));
		return {
			...referral,
			user: { id, name, email },
			referredUsers
		};
	}

	private createUniqueReferralCode(): string {
		return shortid.generate();
	}

	async saveReferralCode(user: User, code: string) {
		const referral = this.referralRepository.create({ user, code });
		referral.referralUrl = await this.createReferralUrl(code);
		await this.referralRepository.save(referral);
		return referral;
	}

	async handleNewUserSignup(
		userId: string,
		referralCode: string
	): Promise<void> {
		const referral = await this.referralRepository.findOne({
			where: { code: referralCode },
			relations: ['referredUsers', 'user']
		});

		if (referral) {
			const user = await this.userService.findOne(userId);

			if (user) {
				const alreadyJoined = referral.referredUsers.some(
					referredUser => referredUser.id === userId
				);
				if (!alreadyJoined) {
					await this.generateReferralCode(userId);
					user.referrer = referral;
					await this.userService.save(user);
					referral.referredUsers.push(user);
					//  Create a new ReferralUsage record
					const referralUsage = new ReferralUsage();
					referralUsage.user = user; // The user who used the referral code
					referralUsage.referral = referral; // The referral code used
					referralUsage.reward = this.calculateReward(0); // Calculate the reward here
					await this.referralUsageRepository.save(referralUsage);
					const rewardsExpiry =
						await this.calculateSubscriptionRewards(referral.id);
					//  Reward the user whose referral code was used
					await this.rewardReferrer(
						referral.user.id,
						1,
						rewardsExpiry
					);
				} else {
					throw new ConflictException(
						`User ${userId} has already joined using referral code ${referralCode}.`
					);
				}
			}
		}
	}
	calculateReward(rewardAmount: number): number {
		return rewardAmount;
	}
	async rewardReferrer(
		referrerId: string,
		rewardMonth: number,
		rewardsExpiry: Date | null
	): Promise<void> {
		let currentReward = await this.rewardRepository.findOne({
			where: { user: { id: referrerId } }
		});
		if (currentReward) {
			currentReward.reward += rewardMonth;
			currentReward.rewardsExpiry = rewardsExpiry;
			await this.rewardRepository.save(currentReward);
		} else {
			currentReward = this.rewardRepository.create({
				user: { id: referrerId } as User,
				reward: rewardMonth,
				rewardsExpiry: rewardsExpiry
			});
			await this.rewardRepository.save(currentReward);
		}
	}
	async calculateSubscriptionRewards(
		referralId: string
	): Promise<Date | null> {
		const now = new Date();
		const referral = await this.referralRepository.findOne({
			where: { id: referralId },
			relations: ['referredUsers']
		});
		if (referral) {
			let newExpiryDate = now;
			if (referral.rewardsExpiry) {
				const currentExpiryDate = new Date(referral.rewardsExpiry);
				newExpiryDate = new Date(
					currentExpiryDate.setMonth(currentExpiryDate.getMonth() + 1)
				);
			} else {
				newExpiryDate.setMonth(newExpiryDate.getMonth() + 1);
			}
			referral.rewardsExpiry = newExpiryDate;
			await this.referralRepository.save(referral);
			return newExpiryDate;
		}
		return null;
	}
	async createReferralUrl(referralCode: string) {
		const baseUrl = this.configService.get<string>('REFERRAL_URL');
		if (!baseUrl) {
			throw new Error('REFERRAL_URL is not defined');
		}
		return `${baseUrl}${referralCode}`;
	}
}
