import { AuthOtpRepository } from '@/auth/authOtp.repository';
import { createUser, mockUser } from '@/factories/user.factory';
import {
	BadRequestException,
	ConflictException,
	NotFoundException,
	UnauthorizedException
} from '@nestjs/common';
import { JwtService } from '@nestjs/jwt';
import { Test, TestingModule } from '@nestjs/testing';
import * as bcrypt from 'bcrypt';
import { DataSource } from 'typeorm';
import { User } from '../user/entities/user.entity';
import { UserService } from '../user/user.service';
import { generateUUID7 } from '../utils/uuid7/typeorm-uuid7.utils';
import { AuthService } from './auth.service';
import { EmailService } from './email/email.service';
import { AuthOTP } from './entities/authOtp.entity';
import { NotificationService } from '@/notifications/services/notification.service';
import { NotificationModeEnum } from '@/notifications/enums/notification-mode.enum';

jest.mock('bcrypt');
jest.mock('../utils/uuid7/typeorm-uuid7.utils');

describe('AuthService', () => {
	let service: AuthService;
	let userService: jest.Mocked<UserService>;
	let jwtService: jest.Mocked<JwtService>;
	let emailService: jest.Mocked<EmailService>;
	let authOtpRepository: jest.Mocked<AuthOtpRepository>;
	let notificationService: jest.Mocked<NotificationService>;

	beforeEach(async () => {
		const module: TestingModule = await Test.createTestingModule({
			providers: [
				AuthService,
				{
					provide: UserService,
					useValue: {
						findByEmail: jest.fn(),
						findOne: jest.fn(),
						create: jest.fn(),
						save: jest.fn(),
						findByResetPasswordToken: jest.fn(),
						findByVerificationToken: jest.fn(),
						clearRefreshToken: jest.fn(),
						updateRefreshToken: jest.fn()
					}
				},
				{
					provide: JwtService,
					useValue: {
						sign: jest.fn(),
						decode: jest.fn(),
						verify: jest.fn()
					}
				},
				{
					provide: EmailService,
					useValue: {
						sendVerificationEmail: jest.fn(),
						sendForgotPasswordEmail: jest.fn()
					}
				},
				{
					provide: AuthOtpRepository,
					useValue: {
						find: jest.fn(),
						createOtp: jest.fn(),
						findByUserId: jest.fn(),
						remove: jest.fn()
					}
				},
				{
					provide: DataSource,
					useValue: {
						getRepository: jest.fn()
					}
				},
				{
					provide: NotificationService,
					useValue: {
						sendNotification: jest.fn(),
						send: jest.fn()
					}
				}
			]
		}).compile();

		service = module.get<AuthService>(AuthService);
		userService = module.get(UserService);
		jwtService = module.get(JwtService);
		emailService = module.get(EmailService);
		authOtpRepository = module.get(AuthOtpRepository);
		notificationService = module.get(NotificationService);
	});

	it('should be defined', () => {
		expect(service).toBeDefined();
	});

	describe('googleLogin', () => {
		it('should return "No user from google" if req.user is not present', async () => {
			const req = {};
			const result = await service.googleLogin(req);
			expect(result).toBe('No user from google');
		});

		it('should create a new user and return a token if the user does not exist', async () => {
			const req = {
				user: {
					email: 'test@example.com',
					firstName: 'Test',
					lastName: 'User'
				}
			};

			jest.spyOn(userService, 'findByEmail').mockResolvedValue(null);
			jest.spyOn(userService, 'create').mockResolvedValue(mockUser);
			jest.spyOn(jwtService, 'sign').mockReturnValueOnce('test-token');
			jest.spyOn(jwtService, 'sign').mockReturnValueOnce(
				'test-refresh-token'
			);

			const result = await service.googleLogin(req);
			expect(userService.findByEmail).toHaveBeenCalledWith(
				req.user.email
			);
			expect(userService.create).toHaveBeenCalledWith({
				name: `${req.user.firstName} ${req.user.lastName}`,
				email: req.user.email,
				password: '',
				isVerified: true
			});
			expect(result).toEqual({
				access_token: 'test-token',
				refresh_token: 'test-refresh-token'
			});
		});

		it('should return a token if the user already exists', async () => {
			const req = {
				user: {
					email: 'test@example.com',
					firstName: 'Test',
					lastName: 'User'
				}
			};

			(mockUser.id = 'existing-user-id'),
				(mockUser.name = 'name'),
				(mockUser.email = 'test@example.com'),
				jest
					.spyOn(userService, 'findByEmail')
					.mockResolvedValue(mockUser);
			jest.spyOn(jwtService, 'sign').mockReturnValueOnce('test-token');
			jest.spyOn(jwtService, 'sign').mockReturnValueOnce(
				'test-refresh-token'
			);
			jest.spyOn(userService, 'updateRefreshToken').mockResolvedValue();

			const result = await service.googleLogin(req);
			expect(userService.findByEmail).toHaveBeenCalledWith(
				req.user.email
			);
			expect(userService.create).not.toHaveBeenCalled();
			expect(result).toEqual({
				access_token: 'test-token',
				refresh_token: 'test-refresh-token'
			});
		});
	});

	describe('register', () => {
		it('should register a new user', async () => {
			const registerDto = {
				email: 'new@example.com',
				password: 'password',
				name: 'New User'
			};
			userService.findByEmail.mockResolvedValue(null);
			(bcrypt.hash as jest.Mock).mockResolvedValue('hashedPassword');
			(generateUUID7 as jest.Mock).mockReturnValue('verificationToken');
			userService.create.mockResolvedValue({
				...mockUser,
				...registerDto,
				password: 'hashedPassword',
				isVerified: false,
				verificationToken: 'verificationToken'
			});

			await expect(service.register(registerDto)).resolves.toEqual({
				message:
					'User registered. Please check your email for verification.'
			});

			expect(emailService.sendVerificationEmail).toHaveBeenCalledWith(
				'new@example.com',
				'verificationToken'
			);
		});

		it('should throw ConflictException if user already exists', async () => {
			const registerDto = {
				email: 'existing@example.com',
				password: 'password',
				name: 'Existing User'
			};
			userService.findByEmail.mockResolvedValue({
				...mockUser,
				email: 'existing@example.com'
			});

			await expect(service.register(registerDto)).rejects.toThrow(
				ConflictException
			);
		});
	});

	describe('saveRefreshAccessToken', () => {
		it('should call userService.updateRefreshToke with userId and refreshToken', async () => {
			const data = {
				userId: '1',
				refreshToken: 'test-refresh-token'
			};
			jest.spyOn(userService, 'updateRefreshToken').mockResolvedValue();
			const result = await service.saveRefreshAccessToken(
				data.userId,
				data.refreshToken
			);
			expect(userService.updateRefreshToken).toHaveBeenCalledWith(
				data.userId,
				data.refreshToken
			);
			expect(result).toEqual(undefined);
		});
	});

	describe('refreshAccessToken', () => {
		it('should return a new access token when refresh access token is valid', async () => {
			const refreshTokenDto = {
				refresh_token: 'valid-test-refresh-token'
			};
			const payload = { sub: 'user-id' };
			const user: Partial<User> = {
				id: 'user-id',
				email: 'test@example.com',
				refreshToken: 'hashed-refresh-token'
			};

			jest.spyOn(jwtService, 'verify').mockReturnValue(payload);
			jest.spyOn(userService, 'findOne').mockResolvedValue(user as User);
			jest.spyOn(bcrypt, 'compare').mockImplementation(() =>
				Promise.resolve(true)
			);
			jest.spyOn(jwtService, 'sign').mockReturnValue('new-access-token');

			const result = await service.refreshAccessToken(refreshTokenDto);
			expect(jwtService.verify).toHaveBeenCalledWith(
				refreshTokenDto.refresh_token
			);
			expect(userService.findOne).toHaveBeenCalledWith(payload.sub);
			expect(bcrypt.compare).toHaveBeenCalledWith(
				refreshTokenDto.refresh_token,
				user.refreshToken
			);
			expect(jwtService.sign).toHaveBeenCalledWith(
				{ userId: user.id, email: user.email },
				{ expiresIn: '60m' }
			);
			expect(result).toEqual({ accessToken: 'new-access-token' });
		});

		it('should throw an UnauthorizedException if the user is not found', async () => {
			const refreshTokenDto = {
				refresh_token: 'valid-test-refresh-token'
			};
			const payload = { sub: 'user-id' };

			jest.spyOn(jwtService, 'verify').mockReturnValue(payload);
			jest.spyOn(userService, 'findOne').mockRejectedValue(
				new NotFoundException(`User with ID not found`)
			);

			await expect(
				service.refreshAccessToken(refreshTokenDto)
			).rejects.toThrow(
				new UnauthorizedException('Refresh token is invalid or expired')
			);
		});

		it('should throw an UnauthorizedException if the refresh token is invalid', async () => {
			const refreshTokenDto = {
				refresh_token: 'invalid-test-refresh-token'
			};
			const payload = { sub: 'user-id' };
			const user: Partial<User> = {
				id: 'user-id',
				email: 'test@example.com',
				refreshToken: 'hashed-refresh-token'
			};

			jest.spyOn(jwtService, 'verify').mockReturnValue(payload);
			jest.spyOn(userService, 'findOne').mockResolvedValue(user as User);
			jest.spyOn(bcrypt, 'compare').mockImplementation(() =>
				Promise.resolve(false)
			);

			await expect(
				service.refreshAccessToken(refreshTokenDto)
			).rejects.toThrow(
				new UnauthorizedException('Refresh token is invalid or expired')
			);
		});
	});

	describe('login', () => {
		it('should login a user and return a token', async () => {
			const loginDto = {
				email: mockUser.email,
				password: mockUser.password
			};
			mockUser.isVerified = true;
			userService.findByEmail.mockResolvedValue(mockUser);
			(bcrypt.compare as jest.Mock).mockResolvedValue(true);
			jwtService.sign.mockReturnValueOnce('token');
			const result = await service.login(loginDto);
			expect(result).toEqual({
				access_token: 'token'
			});
		});

		it('should throw UnauthorizedException if user is not found', async () => {
			const loginDto = {
				email: 'nonexistent@example.com',
				password: 'password'
			};
			userService.findByEmail.mockResolvedValue(null);

			await expect(service.login(loginDto)).rejects.toThrow(
				UnauthorizedException
			);
		});

		it('should throw UnauthorizedException if user is not verified', async () => {
			const loginDto = {
				email: 'unverified@example.com',
				password: 'password'
			};
			userService.findByEmail.mockResolvedValue({
				...mockUser,
				isVerified: false
			});

			await expect(service.login(loginDto)).rejects.toThrow(
				UnauthorizedException
			);
		});

		it('should throw UnauthorizedException if password is invalid', async () => {
			const loginDto = {
				email: 'test@example.com',
				password: 'wrongpassword'
			};
			userService.findByEmail.mockResolvedValue(mockUser);
			(bcrypt.compare as jest.Mock).mockResolvedValue(false);

			await expect(service.login(loginDto)).rejects.toThrow(
				UnauthorizedException
			);
		});
	});

	describe('forgotPassword', () => {
		it('should generate reset token and send email', async () => {
			const forgotPasswordDto = { email: 'test@example.com' };
			userService.findByEmail.mockResolvedValue(mockUser);
			(generateUUID7 as jest.Mock).mockReturnValue('resetToken');

			await expect(
				service.forgotPassword(forgotPasswordDto)
			).resolves.toEqual({
				message: 'Reset password instructions sent to email'
			});

			expect(emailService.sendForgotPasswordEmail).toHaveBeenCalledWith(
				'test@example.com',
				'resetToken'
			);
		});

		it('should throw NotFoundException if user is not found', async () => {
			const forgotPasswordDto = { email: 'nonexistent@example.com' };
			userService.findByEmail.mockResolvedValue(null);

			await expect(
				service.forgotPassword(forgotPasswordDto)
			).rejects.toThrow(NotFoundException);
		});
	});

	describe('verifyResetPasswordToken', () => {
		it('should verify a valid reset password token', async () => {
			const token = 'validToken';
			const user: User = {
				...mockUser,
				resetPasswordToken: 'validToken',
				resetPasswordExpires: new Date(Date.now() + 3600000)
			};
			userService.findByResetPasswordToken.mockResolvedValue(user);

			await expect(
				service.verifyResetPasswordToken(token)
			).resolves.toEqual({
				message: 'Password reset token is valid'
			});
		});

		it('should throw BadRequestException for invalid token', async () => {
			const token = 'invalidToken';
			userService.findByResetPasswordToken.mockResolvedValue(null);

			await expect(
				service.verifyResetPasswordToken(token)
			).rejects.toThrow(BadRequestException);
		});

		it('should throw BadRequestException for expired token', async () => {
			const token = 'expiredToken';
			const user: User = {
				...mockUser,
				resetPasswordToken: 'expiredToken',
				resetPasswordExpires: new Date(Date.now() - 3600000)
			};
			userService.findByResetPasswordToken.mockResolvedValue(user);

			await expect(
				service.verifyResetPasswordToken(token)
			).rejects.toThrow(BadRequestException);
		});
	});

	describe('resetPassword', () => {
		it('should reset password successfully', async () => {
			const resetPasswordDto = {
				token: 'validToken',
				newPassword: 'newPassword'
			};
			const user: User = {
				...mockUser,
				resetPasswordToken: 'validToken',
				resetPasswordExpires: new Date(Date.now() + 3600000)
			};
			userService.findByResetPasswordToken.mockResolvedValue(user);
			(bcrypt.hash as jest.Mock).mockResolvedValue('newHashedPassword');

			await expect(
				service.resetPassword(resetPasswordDto)
			).resolves.toEqual({
				message: 'Password has been reset successfully'
			});

			expect(userService.save).toHaveBeenCalledWith(
				expect.objectContaining({
					...user,
					password: 'newHashedPassword',
					resetPasswordToken: null,
					resetPasswordExpires: null
				})
			);
		});

		it('should throw BadRequestException for invalid token', async () => {
			const resetPasswordDto = {
				token: 'invalidToken',
				newPassword: 'newPassword'
			};
			userService.findByResetPasswordToken.mockResolvedValue(null);

			await expect(
				service.resetPassword(resetPasswordDto)
			).rejects.toThrow(BadRequestException);
		});

		it('should throw BadRequestException for expired token', async () => {
			const resetPasswordDto = {
				token: 'expiredToken',
				newPassword: 'newPassword'
			};
			const user: User = {
				...mockUser,
				resetPasswordToken: 'expiredToken',
				resetPasswordExpires: new Date(Date.now() - 3600000)
			};
			userService.findByResetPasswordToken.mockResolvedValue(user);

			await expect(
				service.resetPassword(resetPasswordDto)
			).rejects.toThrow(BadRequestException);
		});
	});

	describe('verifyEmail', () => {
		it('should verify email successfully', async () => {
			const token = 'validToken';
			const user: User = {
				...mockUser,
				isVerified: false,
				verificationToken: 'validToken'
			};
			userService.findByVerificationToken.mockResolvedValue(user);

			await expect(service.verifyEmail(token)).resolves.toEqual({
				message: 'Email verified successfully'
			});

			expect(userService.save).toHaveBeenCalledWith(
				expect.objectContaining({
					...user,
					isVerified: true,
					verificationToken: null
				})
			);
		});

		it('should throw BadRequestException for invalid token', async () => {
			const token = 'invalidToken';
			userService.findByVerificationToken.mockResolvedValue(null);

			await expect(service.verifyEmail(token)).rejects.toThrow(
				BadRequestException
			);
		});
	});
	describe('logout', () => {
		it('should throw UnauthorizedException if no token is provided', async () => {
			await expect(service.logout(null)).rejects.toThrow(
				UnauthorizedException
			);
		});

		it('should return success message if token is valid', async () => {
			const mockToken = 'mockValidToken';
			const mockPayload = { email: 'test@napses.com', sub: 1 };
			const mockNewToken = 'newMockToken';

			jest.spyOn(jwtService, 'decode').mockReturnValue(mockPayload);
			jest.spyOn(jwtService, 'sign').mockReturnValue(mockNewToken);
			jest.spyOn(userService, 'clearRefreshToken').mockResolvedValue(
				undefined as any
			);

			const result = await service.logout(mockToken);
			expect(jwtService.decode).toHaveBeenCalledWith(mockToken);
			expect(jwtService.sign).toHaveBeenCalledWith(
				{ email: mockPayload.email, sub: mockPayload.sub },
				{ expiresIn: '50ms' }
			);
			expect(result).toEqual({ message: 'Logged out successfully' });
		});

		it('should throw BadRequestException if an error occurs during logout', async () => {
			const mockToken = 'mockInvalidToken';

			jest.spyOn(jwtService, 'decode').mockImplementation(() => {
				throw new Error('Invalid token');
			});

			await expect(service.logout(mockToken)).rejects.toThrow(
				BadRequestException
			);
		});
	});

	describe('emailLogin', () => {
		it('should throw NotFoundException if user does not exist', async () => {
			jest.spyOn(userService, 'findByEmail').mockResolvedValue(null);

			await expect(
				service.emailLogin({ email: 'test@example.com' })
			).rejects.toThrow(new NotFoundException('User not found'));
		});
		it('should generate OTP and create a new OTP entry in the database, and send an OTP via EMAIL', async () => {
			const user = await createUser();
			const otp = '123456';
			const otpExpiresAt = new Date();
			otpExpiresAt.setMinutes(otpExpiresAt.getMinutes() + 1);
			const data = {
				name: user.name,
				email: user.email,
				otp: otp,
				expiry: '1'
			};
			jest.spyOn(userService, 'findByEmail').mockResolvedValue(user);
			jest.spyOn(authOtpRepository, 'createOtp').mockResolvedValue(
				undefined as any
			);
			jest.spyOn(notificationService, 'send').mockResolvedValue();

			await service.emailLogin({ email: user.email });

			expect(authOtpRepository.createOtp).toHaveBeenCalledWith(
				user,
				expect.any(String),
				expect.any(Date)
			);
			expect(notificationService.send).toHaveBeenCalledWith(
				[NotificationModeEnum.EMAIL],
				'customer-otp',
				data
			);
		});
	});

	describe('verifyOtp', () => {
		it('should throw NotFoundException if user does not exist', async () => {
			jest.spyOn(userService, 'findByEmail').mockResolvedValue(null);

			await expect(
				service.verifyOtp({ email: 'test@example.com', otp: '123456' })
			).rejects.toThrow(new NotFoundException('User not found'));
		});

		it('should throw BadRequestException if no OTP is found', async () => {
			const user = await createUser();
			jest.spyOn(userService, 'findByEmail').mockResolvedValue(user);
			jest.spyOn(authOtpRepository, 'findByUserId').mockResolvedValue(
				null
			);

			await expect(
				service.verifyOtp({ email: 'test@example.com', otp: '123456' })
			).rejects.toThrow(
				new BadRequestException(
					'No OTP found or it has already been used'
				)
			);
		});

		it('should throw BadRequestException if OTP is expired', async () => {
			const user = await createUser();
			const expiredOtp = {
				otp: 'hashedOtp',
				expiresAt: new Date(Date.now() - 1000)
			}; // expired OTP
			jest.spyOn(userService, 'findByEmail').mockResolvedValue(user);
			jest.spyOn(authOtpRepository, 'findByUserId').mockResolvedValue(
				expiredOtp as AuthOTP
			);

			await expect(
				service.verifyOtp({ email: user.email, otp: '123456' })
			).rejects.toThrow(new BadRequestException('OTP expired'));
		});

		it('should throw BadRequestException if OTP is invalid', async () => {
			const user = await createUser();

			const validOtp = {
				otp: 'hashedOtp',
				expiresAt: new Date(Date.now() + 60000)
			}; // valid OTP
			jest.spyOn(userService, 'findByEmail').mockResolvedValue(user);
			jest.spyOn(authOtpRepository, 'findByUserId').mockResolvedValue(
				validOtp as AuthOTP
			);
			jest.spyOn(bcrypt, 'compare').mockResolvedValue(false as never); // invalid OTP

			await expect(
				service.verifyOtp({
					email: 'test@example.com',
					otp: 'wrongOtp'
				})
			).rejects.toThrow(new BadRequestException('Invalid OTP'));
		});

		it('should verify OTP, mark user as verified, and return access token', async () => {
			const user = await createUser();
			user.isVerified = false;
			const validOtp = {
				otp: 'hashedOtp',
				expiresAt: new Date(Date.now() + 60000)
			};
			jest.spyOn(userService, 'findByEmail').mockResolvedValue(user);
			jest.spyOn(authOtpRepository, 'findByUserId').mockResolvedValue(
				validOtp as AuthOTP
			);
			jest.spyOn(bcrypt, 'compare').mockResolvedValue(true as never);
			jest.spyOn(userService, 'save').mockResolvedValue(user);
			jest.spyOn(authOtpRepository, 'remove').mockResolvedValue(
				undefined as any
			);
			jest.spyOn(service, 'removeExpiredOtps').mockResolvedValue(
				undefined
			);
			jwtService.sign.mockReturnValue('token123');
			const result = await service.verifyOtp({
				email: user.email,
				otp: '123456'
			});
			expect(userService.save).toHaveBeenCalledWith({
				...user,
				isVerified: true
			});
			expect(authOtpRepository.remove).toHaveBeenCalledWith(validOtp);
			expect(service.removeExpiredOtps).toHaveBeenCalledWith(user.id);
			expect(result).toEqual({
				access_token: 'token123',
				refresh_token: 'token123'
			});
		});
	});

	describe('removeExpiredOtps', () => {
		it('should remove expired OTPs if they exist', async () => {
			const userId = 'test-user-id';
			const currentTime = new Date();
			const expiredOtps = [
				{
					id: 'otp1',
					user: { id: userId },
					expiresAt: new Date(currentTime.getTime() - 1000)
				},
				{
					id: 'otp2',
					user: { id: userId },
					expiresAt: new Date(currentTime.getTime() - 2000)
				}
			];

			authOtpRepository.find.mockResolvedValue(expiredOtps as any);

			await service.removeExpiredOtps(userId);

			expect(authOtpRepository.find).toHaveBeenCalledWith({
				where: {
					user: { id: userId },
					expiresAt: expect.any(Object)
				}
			});
			expect(authOtpRepository.remove).toHaveBeenCalledWith(expiredOtps);
		});

		it('should not remove OTPs if no expired OTPs are found', async () => {
			const userId = 'test-user-id';

			authOtpRepository.find.mockResolvedValue([]);

			await service.removeExpiredOtps(userId);

			expect(authOtpRepository.find).toHaveBeenCalledWith({
				where: {
					user: { id: userId },
					expiresAt: expect.anything()
				}
			});
			expect(authOtpRepository.remove).not.toHaveBeenCalled();
		});
	});
});
