import { mockReferral } from '@/factories/referral.factory';
import { mockUser } from '@/factories/user.factory';
import { User } from '@/user/entities/user.entity';
import { UserService } from '@/user/user.service';
import { ConflictException, NotFoundException } from '@nestjs/common';
import { ConfigService } from '@nestjs/config';
import { Test, TestingModule } from '@nestjs/testing';
import { getRepositoryToken } from '@nestjs/typeorm';
import { Repository } from 'typeorm';
import { ReferralReward } from './entities/referral-reward.entity';
import { ReferralUsage } from './entities/referral-usage.entity';
import { Referral } from './entities/referral.entity';
import { ReferralService } from './referral.service';

describe('ReferralService', () => {
	let referralService: ReferralService;
	let referralRepository: Repository<Referral>;
	let rewardRepository: any;
	let referralUsageRepository: any;
	let userService: any;

	const mockReferralRepository = {
		findOne: jest.fn(),
		create: jest.fn(),
		save: jest.fn()
	};

	const mockUserService = {
		findOne: jest.fn(),
		save: jest.fn()
	};

	const mockConfigService = {
		get: jest.fn().mockReturnValue('http://example.com/referrals/')
	};

	beforeEach(async () => {
		rewardRepository = {
			findOne: jest.fn(),
			save: jest.fn(),
			create: jest.fn()
		};
		referralUsageRepository = {
			find: jest.fn(),
			save: jest.fn()
		};

		userService = {
			findOne: jest.fn(),
			save: jest.fn()
		};

		const module: TestingModule = await Test.createTestingModule({
			providers: [
				ReferralService,
				{
					provide: getRepositoryToken(Referral),
					useValue: mockReferralRepository
				},
				{
					provide: UserService,
					useValue: mockUserService
				},
				{
					provide: ConfigService,
					useValue: mockConfigService
				},
				{
					provide: getRepositoryToken(ReferralReward),
					useValue: rewardRepository
				},
				{
					provide: getRepositoryToken(ReferralUsage),
					useValue: referralUsageRepository
				},
				{
					provide: UserService,
					useValue: userService
				}
			]
		}).compile();

		referralService = module.get<ReferralService>(ReferralService);
		referralRepository = module.get<Repository<Referral>>(
			getRepositoryToken(Referral)
		);
	});

	it('should be defined', () => {
		expect(referralService).toBeDefined();
	});

	describe('generateReferralCode', () => {
		it('should generate and return a referral code if not existing', async () => {
			mockUserService.findOne.mockResolvedValue(mockReferral.user);
			mockReferralRepository.findOne.mockResolvedValue(null);
			mockReferralRepository.create.mockReturnValue(mockReferral);
			mockReferralRepository.save.mockResolvedValue(mockReferral);
			jest.spyOn(
				referralService as any,
				'createReferralUrl'
			).mockResolvedValue('http://example.com/referrals/ABC123');
			jest.spyOn(
				referralService,
				'validateReferralCode'
			).mockResolvedValue(mockReferral);
			const result = await referralService.generateReferralCode(
				mockReferral.user.id
			);
			expect(result).toBe(mockReferral);
			expect(mockReferralRepository.save).toHaveBeenCalled();
			expect(referralService.validateReferralCode).toHaveBeenCalledWith(
				mockReferral.code
			);
		});

		it('should return an existing referral code if already generated', async () => {
			mockUserService.findOne.mockResolvedValue(mockReferral);
			mockReferralRepository.findOne.mockResolvedValue(mockReferral);
			jest.spyOn(
				referralService,
				'validateReferralCode'
			).mockResolvedValue(mockReferral);
			const result =
				await referralService.generateReferralCode('valid-uuid');
			expect(result).toBe(mockReferral);
			expect(referralService.validateReferralCode).toHaveBeenCalledWith(
				mockReferral.code
			);
		});
	});

	describe('getReferralCodeByUserId', () => {
		it('should return referral code for a user by userId', async () => {
			mockUserService.findOne.mockResolvedValue(mockReferral.user.id);
			mockReferralRepository.findOne.mockResolvedValue(mockReferral);
			jest.spyOn(
				referralService,
				'validateReferralCode'
			).mockResolvedValue(mockReferral);

			const result = await referralService.getReferralCodeByUserId(
				mockReferral.user.id
			);
			expect(result).toBe(mockReferral);
			expect(referralService.validateReferralCode).toHaveBeenCalledWith(
				mockReferral.code
			);
		});

		it('should throw NotFoundException if referral code not found', async () => {
			mockUserService.findOne.mockResolvedValue(mockReferral.user);
			mockReferralRepository.findOne.mockResolvedValue(null);

			await expect(
				referralService.getReferralCodeByUserId(mockReferral.user.id)
			).rejects.toThrow(NotFoundException);
		});
	});

	describe('validateReferralCode', () => {
		it('should validate and return the referral code', async () => {
			mockReferralRepository.findOne.mockResolvedValue(mockReferral);

			const result = await referralService.validateReferralCode(
				mockReferral.code
			);
			expect(result).toEqual(mockReferral);
		});

		it('should throw NotFoundException if referral code not found', async () => {
			mockReferralRepository.findOne.mockResolvedValue(null);

			await expect(
				referralService.validateReferralCode(mockReferral.code)
			).rejects.toThrow(NotFoundException);
		});
	});

	describe('handleNewUserSignup', () => {
		it('should successfully handle new user signup with referral code', async () => {
			jest.spyOn(referralRepository, 'findOne').mockResolvedValue(
				mockReferral as any
			);
			jest.spyOn(userService, 'findOne').mockResolvedValue(
				mockReferral.user as any
			);
			jest.spyOn(userService, 'save').mockResolvedValue(
				mockReferral.user as any
			);
			jest.spyOn(referralUsageRepository, 'save').mockResolvedValue(
				{} as any
			);

			jest.spyOn(
				referralService,
				'generateReferralCode'
			).mockResolvedValue(undefined as any);
			jest.spyOn(referralService, 'calculateReward').mockReturnValue(10);
			jest.spyOn(
				referralService,
				'calculateSubscriptionRewards'
			).mockResolvedValue(new Date());
			jest.spyOn(referralService, 'rewardReferrer').mockResolvedValue(
				undefined
			);

			await referralService.handleNewUserSignup(
				mockReferral.user.id,
				mockReferral.code
			);

			expect(userService.save).toHaveBeenCalledWith({
				...mockReferral.user,
				referrer: mockReferral
			});

			expect(referralUsageRepository.save).toHaveBeenCalledWith(
				expect.any(ReferralUsage)
			);
			expect(referralService.rewardReferrer).toHaveBeenCalledWith(
				mockReferral.user.id,
				1,
				expect.any(Date)
			);
		});

		it('should throw ConflictException if user has already joined using the referral code', async () => {
			jest.spyOn(referralRepository, 'findOne').mockResolvedValue(
				mockReferral as any
			);
			jest.spyOn(userService, 'findOne').mockResolvedValue(
				mockReferral.user as any
			);

			await expect(
				referralService.handleNewUserSignup(
					mockReferral.user.id,
					mockReferral.code
				)
			).rejects.toThrow(
				new ConflictException(
					`User ${mockReferral.user.id} has already joined using referral code ${mockReferral.code}.`
				)
			);
		});
	});

	describe('calculateSubscriptionRewards', () => {
		it('should update the rewardsExpiry by adding one month', async () => {
			mockReferralRepository.findOne.mockResolvedValue(mockReferral);
			jest.spyOn(referralRepository, 'save').mockResolvedValue(
				mockReferral as any
			);

			await referralService.calculateSubscriptionRewards(mockReferral.id);

			if (mockReferral.rewardsExpiry) {
				const expectedDate = new Date(mockReferral.rewardsExpiry);
				expect(mockReferral.rewardsExpiry).toEqual(expectedDate);
				expect(referralRepository.save).toHaveBeenCalledWith(
					mockReferral
				);
			} else {
				throw new Error(
					'rewardsExpiry is null, cannot perform date operations'
				);
			}
		});

		it('should set the rewardsExpiry if not already set', async () => {
			const mockReferral = {
				id: 'referral123',
				referredUsers: [],
				rewardsExpiry: null
			};

			mockReferralRepository.findOne.mockResolvedValue(mockReferral);
			jest.spyOn(referralRepository, 'save').mockResolvedValue(
				mockReferral as any
			);

			await referralService.calculateSubscriptionRewards('referral123');

			const now = new Date();
			const expectedDate = new Date(now.setMonth(now.getMonth() + 1));

			const roundToSeconds = (date: Date) =>
				new Date(Math.floor(date.getTime() / 1000) * 1000);
			expect(roundToSeconds(mockReferral.rewardsExpiry!)).toEqual(
				roundToSeconds(expectedDate)
			);
			expect(mockReferral.rewardsExpiry).toEqual(expectedDate);
			expect(referralRepository.save).toHaveBeenCalledWith(mockReferral);
		});
	});

	describe('createReferralUrl', () => {
		it('should create and return a referral URL', async () => {
			mockConfigService.get.mockReturnValue(
				'http://example.com/referrals/'
			);

			const result = await referralService['createReferralUrl']('ABC123');
			expect(result).toBe('http://example.com/referrals/ABC123');
		});

		it('should throw an error if baseUrl is not defined', async () => {
			mockConfigService.get.mockReturnValue(null);

			await expect(
				referralService['createReferralUrl']('ABC123')
			).rejects.toThrow('REFERRAL_URL is not defined');
		});
	});

	describe('getReferralRewards', () => {
		it('should return referral rewards for a given user ID', async () => {
			const userId = mockReferral.user.id;

			jest.spyOn(rewardRepository, 'findOne').mockResolvedValue(
				mockUser.referralReward as any
			);

			const result = await referralService.getReferralRewards(userId);

			expect(result).toEqual({
				reward: mockUser.referralReward.reward,
				currentExpiryDate:
					mockUser.referralReward.rewardsExpiry?.toISOString()
			});
			expect(rewardRepository.findOne).toHaveBeenCalledWith({
				where: { user: { id: userId } }
			});
		});

		it('should return null if no rewards found for the user ID', async () => {
			const userId = mockReferral.user.id;
			jest.spyOn(rewardRepository, 'findOne').mockResolvedValue(null);

			const result = await referralService.getReferralRewards(userId);

			expect(result).toBeNull();
			expect(rewardRepository.findOne).toHaveBeenCalledWith({
				where: { user: { id: userId } }
			});
		});
	});

	describe('getReferralUsageByReferralId', () => {
		it('should return referral and users who used the referral code', async () => {
			const mockUsers = [
				{
					user: mockReferral.user,
					reward: mockUser.referralReward.reward,
					createdAt: new Date('2024-09-01T12:00:00Z')
				},
				{
					user: mockReferral.user,
					reward: mockUser.referralReward.reward,
					createdAt: new Date('2024-09-03T15:30:00Z')
				}
			];

			jest.spyOn(referralRepository, 'findOne').mockResolvedValue(
				mockReferral as any
			);
			jest.spyOn(referralUsageRepository, 'find').mockResolvedValue(
				mockUsers as any
			);

			const result = await referralService.getReferralUsageByReferralId(
				mockReferral.id
			);
			const ans = {
				referral: {
					referralId: mockReferral.id,
					referralCode: mockReferral.code
				},
				users: [
					{
						id: mockReferral.user.id,
						name: mockReferral.user.name,
						email: mockReferral.user.email
					},
					{
						id: mockReferral.user.id,
						name: mockReferral.user.name,
						email: mockReferral.user.email
					}
				]
			};
			expect(result).toEqual(ans);
			expect(referralRepository.findOne).toHaveBeenCalledWith({
				where: { id: mockReferral.id },
				relations: ['referralUsages']
			});
			expect(referralUsageRepository.find).toHaveBeenCalledWith({
				where: { referral: { id: mockReferral.id } },
				relations: ['user']
			});
		});

		it('should throw NotFoundException if referral is not found', async () => {
			const referralId = mockReferral.id;
			jest.spyOn(referralRepository, 'findOne').mockResolvedValue(null);

			await expect(
				referralService.getReferralUsageByReferralId(referralId)
			).rejects.toThrow(
				new NotFoundException(
					`Referral with ID ${referralId} not found`
				)
			);
		});
	});

	describe('rewardReferrer', () => {
		it('should update existing reward if reward already exists', async () => {
			const referrerId = mockReferral.id;
			const rewardMonth = mockUser.referralReward.reward;
			const rewardsExpiry = mockUser.referralReward.rewardsExpiry;

			const existingReward = {
				user: { id: referrerId },
				reward: 5,
				rewardsExpiry: new Date('2024-09-10T00:00:00Z')
			} as ReferralReward;

			jest.spyOn(rewardRepository, 'findOne').mockResolvedValue(
				existingReward
			);
			jest.spyOn(rewardRepository, 'save').mockResolvedValue(undefined);
			const expectedReward = existingReward.reward + rewardMonth;

			await referralService.rewardReferrer(
				referrerId,
				rewardMonth,
				rewardsExpiry
			);
			expect(rewardRepository.findOne).toHaveBeenCalledWith({
				where: { user: { id: referrerId } }
			});

			expect(rewardRepository.save).toHaveBeenCalledWith({
				...existingReward,
				reward: expectedReward,
				rewardsExpiry: rewardsExpiry
			});
		});

		it('should create and save a new reward if no existing reward is found', async () => {
			const referrerId = mockReferral.id;
			const rewardMonth = mockUser.referralReward.reward;
			const rewardsExpiry = mockUser.referralReward.rewardsExpiry;

			jest.spyOn(rewardRepository, 'findOne').mockResolvedValue(null);
			jest.spyOn(rewardRepository, 'create').mockReturnValue({
				user: { id: referrerId } as User,
				reward: rewardMonth,
				rewardsExpiry: rewardsExpiry
			} as ReferralReward);
			jest.spyOn(rewardRepository, 'save').mockResolvedValue(undefined);

			await referralService.rewardReferrer(
				referrerId,
				rewardMonth,
				rewardsExpiry
			);

			expect(rewardRepository.findOne).toHaveBeenCalledWith({
				where: { user: { id: referrerId } }
			});
			expect(rewardRepository.create).toHaveBeenCalledWith({
				user: { id: referrerId } as User,
				reward: rewardMonth,
				rewardsExpiry: rewardsExpiry
			});
			expect(rewardRepository.save).toHaveBeenCalledWith({
				user: { id: referrerId } as User,
				reward: rewardMonth,
				rewardsExpiry: rewardsExpiry
			});
		});
	});
});
