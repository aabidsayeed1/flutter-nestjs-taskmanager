import { Test, TestingModule } from '@nestjs/testing';
import { ReferralController } from './referral.controller';
import { ReferralService } from './referral.service';
import { JwtAuthGuard } from '@/auth/guards/jwt-auth.guard';
import {
	ConflictException,
	NotFoundException,
	UnauthorizedException
} from '@nestjs/common';
import { UserPayload } from '@/user/payloads/user.payload';

describe('ReferralController', () => {
	let referralController: ReferralController;
	let referralService: ReferralService;

	const mockReferralService = {
		generateReferralCode: jest.fn(),
		getReferralCodeByUserId: jest.fn(),
		validateReferralCode: jest.fn(),
		handleNewUserSignup: jest.fn(),
		getReferralRewards: jest.fn(),
		getReferralUsageByReferralId: jest.fn()
	};

	const mockUserPayload: UserPayload = {
		userId: 'valid-uuid',
		email: 'test@example.com'
	};

	const mockRequest = {
		user: mockUserPayload
	} as any;

	beforeEach(async () => {
		const module: TestingModule = await Test.createTestingModule({
			controllers: [ReferralController],
			providers: [
				{
					provide: ReferralService,
					useValue: mockReferralService
				}
			]
		})
			.overrideGuard(JwtAuthGuard)
			.useValue({ canActivate: jest.fn(() => true) })
			.compile();

		referralController = module.get<ReferralController>(ReferralController);
		referralService = module.get<ReferralService>(ReferralService);
	});

	it('should be defined', () => {
		expect(referralController).toBeDefined();
	});

	describe('generateReferralCode', () => {
		it('should generate a referral code for the user', async () => {
			mockReferralService.generateReferralCode.mockResolvedValue(
				'generatedCode'
			);

			const result =
				await referralController.generateReferralCode(mockRequest);
			expect(result).toBe('generatedCode');
			expect(referralService.generateReferralCode).toHaveBeenCalledWith(
				mockUserPayload.userId
			);
		});

		it('should throw UnauthorizedException if user is not found', async () => {
			mockRequest.user = null;

			await expect(
				referralController.generateReferralCode(mockRequest)
			).rejects.toThrow(UnauthorizedException);
		});
	});

	describe('getMyReferralCode', () => {
		it('should return referral code for a user by userId', async () => {
			mockReferralService.getReferralCodeByUserId.mockResolvedValue(
				'referralCode'
			);

			const result = await referralController.getMyReferralCode('123');
			expect(result).toBe('referralCode');
			expect(
				referralService.getReferralCodeByUserId
			).toHaveBeenCalledWith('123');
		});
	});

	describe('validateReferralCode', () => {
		it('should validate the referral code', async () => {
			mockReferralService.validateReferralCode.mockResolvedValue(true);

			const result =
				await referralController.validateReferralCode('code123');
			expect(result).toBe(true);
			expect(referralService.validateReferralCode).toHaveBeenCalledWith(
				'code123'
			);
		});
	});
	describe('handleNewUserSignup', () => {
		it('should call handleNewUserSignup with correct parameters', async () => {
			const userId = 'user123';
			const referralCode = 'ABC123';

			await referralController.handleNewUserSignup(userId, referralCode);

			expect(referralService.handleNewUserSignup).toHaveBeenCalledWith(
				userId,
				referralCode
			);
		});

		it('should throw a ConflictException if user has already joined', async () => {
			const userId = 'user123';
			const referralCode = 'ABC123';

			mockReferralService.handleNewUserSignup.mockRejectedValue(
				new ConflictException(
					`User ${userId} has already joined using referral code ${referralCode}.`
				)
			);

			await expect(
				referralController.handleNewUserSignup(userId, referralCode)
			).rejects.toThrow(
				`User ${userId} has already joined using referral code ${referralCode}.`
			);
		});
	});

	describe('getUserReferralRewards', () => {
		it('should return referral rewards for a given user ID', async () => {
			const userId = 'user123';
			const mockReward = {
				reward: 10,
				currentExpiryDate: new Date('2024-09-10T00:00:00Z')
			};

			jest.spyOn(referralService, 'getReferralRewards').mockResolvedValue(
				mockReward
			);

			expect(
				await referralController.getUserReferralRewards(userId)
			).toBe(mockReward);
			expect(referralService.getReferralRewards).toHaveBeenCalledWith(
				userId
			);
		});

		it('should throw an error if user not found', async () => {
			const userId = 'user123';
			jest.spyOn(referralService, 'getReferralRewards').mockRejectedValue(
				new NotFoundException()
			);

			await expect(
				referralController.getUserReferralRewards(userId)
			).rejects.toThrow(NotFoundException);
		});
	});

	describe('getUsersByReferral', () => {
		it('should return users who joined using the referral code', async () => {
			const referralId = 'referral123';
			const mockUsers = {
				referral: {
					referralId: 'referral123',
					referralCode: 'codeadsfa'
				},
				users: [
					{
						email: 'user1@example.com',
						name: 'User One'
					},
					{
						email: 'user2@example.com',
						name: 'User Two'
					}
				]
			};

			jest.spyOn(
				referralService,
				'getReferralUsageByReferralId'
			).mockResolvedValue(mockUsers as any);

			expect(
				await referralController.getReferralUsageByReferral(referralId)
			).toEqual(mockUsers);
			expect(
				referralService.getReferralUsageByReferralId
			).toHaveBeenCalledWith(referralId);
		});

		it('should throw an error if referral not found', async () => {
			const referralId = 'referral123';
			jest.spyOn(
				referralService,
				'getReferralUsageByReferralId'
			).mockRejectedValue(new NotFoundException());

			await expect(
				referralController.getReferralUsageByReferral(referralId)
			).rejects.toThrow(NotFoundException);
		});
	});
});
