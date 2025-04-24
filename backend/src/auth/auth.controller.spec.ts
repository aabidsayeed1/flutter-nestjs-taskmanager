import { mockUser } from '@/factories/user.factory';
import { AuthGuard } from '@nestjs/passport';
import { Test, TestingModule } from '@nestjs/testing';
import { Request } from 'express';
import { AuthController } from './auth.controller';
import { AuthService } from './auth.service';
import { ForgotPasswordDto } from './dto/forgot-password.dto';
import { LoginEmailDto } from './dto/login-email.dto'; // Import LoginEmailDto
import { LoginDto } from './dto/login.dto';
import { RefreshTokenDto } from './dto/refresh-token.dto';
import { RegisterDto } from './dto/register.dto';
import { ResetPasswordDto } from './dto/reset-password.dto';
import { VerifyOtpDto } from './dto/verify-otp.dto';

describe('AuthController', () => {
	let controller: AuthController;
	let authService: jest.Mocked<AuthService>;

	beforeEach(async () => {
		const mockAuthService = {
			googleLogin: jest.fn(),
			register: jest.fn(),
			login: jest.fn(),
			verifyEmail: jest.fn(),
			forgotPassword: jest.fn(),
			verifyResetPasswordToken: jest.fn(),
			resetPassword: jest.fn(),
			logout: jest.fn(),
			emailLogin: jest.fn(),
			verifyOtp: jest.fn(),
			refreshAccessToken: jest.fn()
		};

		const module: TestingModule = await Test.createTestingModule({
			controllers: [AuthController],
			providers: [
				{
					provide: AuthService,
					useValue: mockAuthService
				}
			]
		}).compile();

		controller = module.get<AuthController>(AuthController);
		authService = module.get(AuthService);
	});

	it('should be defined', () => {
		expect(controller).toBeDefined();
	});

	describe('googleAuth', () => {
		it('should have AuthGuard applied', async () => {
			const guards = Reflect.getMetadata(
				'__guards__',
				controller.googleAuth
			);
			expect(guards).toHaveLength(1);
			expect(guards[0]).toBe(AuthGuard('google'));
		});

		it('should call googleLogin on googleAuthRedirect', async () => {
			const req = { user: { email: 'test@example.com' } };
			const result = {
				access_token: 'test-token',
				refresh_token: 'test-refresh-token'
			};
			jest.spyOn(authService, 'googleLogin').mockResolvedValue(result);

			expect(await controller.googleAuthRedirect(req)).toBe(result);
			expect(authService.googleLogin).toHaveBeenCalledWith(req);
		});
	});
	describe('register', () => {
		it('should call authService.register with registerDto', async () => {
			const registerDto: RegisterDto = {
				name: 'Test User',
				email: 'test@example.com',
				password: 'password123'
			};
			await controller.register(registerDto);
			expect(authService.register).toHaveBeenCalledWith(registerDto);
		});
	});

	describe('login', () => {
		it('should call authService.login with loginDto', async () => {
			const loginDto: LoginDto = {
				email: 'test@example.com',
				password: 'password123'
			};
			await controller.login(loginDto);
			expect(authService.login).toHaveBeenCalledWith(loginDto);
		});
	});

	describe('verifyEmail', () => {
		it('should call authService.verifyEmail with token', async () => {
			const token = 'verify-token';
			await controller.verifyEmail(token);
			expect(authService.verifyEmail).toHaveBeenCalledWith(token);
		});
	});

	describe('forgotPassword', () => {
		it('should call authService.forgotPassword with forgotPasswordDto', async () => {
			const forgotPasswordDto: ForgotPasswordDto = {
				email: 'test@example.com'
			};
			await controller.forgotPassword(forgotPasswordDto);
			expect(authService.forgotPassword).toHaveBeenCalledWith(
				forgotPasswordDto
			);
		});
	});

	describe('verifyResetPasswordToken', () => {
		it('should call authService.verifyResetPasswordToken with token', async () => {
			const token = 'reset-token';
			await controller.verifyResetPasswordToken(token);
			expect(authService.verifyResetPasswordToken).toHaveBeenCalledWith(
				token
			);
		});
	});

	describe('resetPassword', () => {
		it('should call authService.resetPassword with resetPasswordDto', async () => {
			const resetPasswordDto: ResetPasswordDto = {
				token: 'reset-token',
				newPassword: 'newpassword123'
			};
			await controller.resetPassword(resetPasswordDto);
			expect(authService.resetPassword).toHaveBeenCalledWith(
				resetPasswordDto
			);
		});
	});

	describe('logout', () => {
		it('should call AuthService.logout with the correct token when a token is provided', async () => {
			const mockRequest = {
				headers: {
					authorization: 'Bearer mockToken'
				}
			};

			const mockResponse = { message: 'Logged out successfully' };
			jest.spyOn(authService, 'logout').mockResolvedValue(mockResponse);
			const result = await controller.logout(mockRequest as Request);
			expect(authService.logout).toHaveBeenCalledWith('mockToken');
			expect(result).toBe(mockResponse);
		});

		it('should call AuthService.logout with null when no token is provided', async () => {
			const mockRequest = {
				headers: {
					authorization: undefined
				}
			};
			const mockResponse = { message: 'No token provided' };
			jest.spyOn(authService, 'logout').mockResolvedValue(mockResponse);
			const result = await controller.logout(mockRequest as Request);
			expect(authService.logout).toHaveBeenCalledWith(null);
			expect(result).toBe(mockResponse);
		});
	});

	describe('refresh-token', () => {
		it('should call authService.refreshAccessToken with refreshTokenDto', async () => {
			const refreshTokenDto: RefreshTokenDto = {
				refresh_token: 'test-refresh-token'
			};
			await controller.refreshToken(refreshTokenDto);
			expect(authService.refreshAccessToken).toHaveBeenCalledWith(
				refreshTokenDto
			);
		});
	});

	describe('loginEmail', () => {
		it('should call authService.emailLogin with loginEmailDto', async () => {
			const loginEmailDto: LoginEmailDto = {
				email: 'test@example.com'
			};

			jest.spyOn(authService, 'emailLogin').mockResolvedValue(mockUser);

			const response = await controller.loginEmail(loginEmailDto);
			expect(authService.emailLogin).toHaveBeenCalledWith(loginEmailDto);
			expect(response).toEqual(mockUser);
		});
	});
	describe('verifyOtp', () => {
		it('should return access_token when OTP is verified successfully', async () => {
			const verifyOtpDto: VerifyOtpDto = {
				otp: '123456',
				email: '1234567890'
			};

			const expectedResult = {
				access_token: '123123123213123',
				refresh_token: '123123123123123123546576'
			};

			jest.spyOn(authService, 'verifyOtp').mockResolvedValue(
				expectedResult
			);

			const result = await controller.verifyOtp(verifyOtpDto);

			expect(result).toEqual(expectedResult);
			expect(authService.verifyOtp).toHaveBeenCalledWith(verifyOtpDto);
		});

		it('should throw an error when OTP verification fails', async () => {
			const verifyOtpDto: VerifyOtpDto = {
				otp: '123456',
				email: '1234567890'
			};

			jest.spyOn(authService, 'verifyOtp').mockRejectedValue(
				new Error('Invalid OTP')
			);

			await expect(controller.verifyOtp(verifyOtpDto)).rejects.toThrow(
				'Invalid OTP'
			);
			expect(authService.verifyOtp).toHaveBeenCalledWith(verifyOtpDto);
		});
	});
});
