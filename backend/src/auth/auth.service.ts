import { AuthOtpRepository } from '@/auth/authOtp.repository';
import { LoginEmailDto } from '@/auth/dto/login-email.dto';
import { NotificationModeEnum } from '@/notifications/enums/notification-mode.enum';
import { NotificationService } from '@/notifications/services/notification.service';
import { generateHash, generateOtp } from '@/utils/generators/otp';
import {
	BadRequestException,
	ConflictException,
	Injectable,
	InternalServerErrorException,
	NotFoundException,
	UnauthorizedException
} from '@nestjs/common';
import { JwtService } from '@nestjs/jwt';
import * as bcrypt from 'bcrypt';
import { LessThan } from 'typeorm';
import { UserService } from '../user/user.service';
import { generateUUID7 } from '../utils/uuid7/typeorm-uuid7.utils';
import { ForgotPasswordDto } from './dto/forgot-password.dto';
import { LoginDto } from './dto/login.dto';
import { RefreshTokenDto } from './dto/refresh-token.dto';
import { RegisterDto } from './dto/register.dto';
import { ResetPasswordDto } from './dto/reset-password.dto';
import { VerifyOtpDto } from './dto/verify-otp.dto';
import { EmailService } from './email/email.service';
import { PhoneNumberLoginDto } from './dto/login-phone-number.dto';
import { User } from '@/user/entities/user.entity';
import { I18nHelperService } from '@/i18n-helper/i18n-helper.service';

@Injectable()
export class AuthService {
	constructor(
		private userService: UserService,
		private jwtService: JwtService,
		private emailService: EmailService,
		private readonly authOtpRepository: AuthOtpRepository,
		private notificationService: NotificationService,
		private i18nHelperService: I18nHelperService,

	) {}

	async register(registerDto: RegisterDto) {
		const existingUser = await this.userService.findByEmail(
			registerDto.email
		);
		if (existingUser) {
			throw new ConflictException('User with this email already exists');
		}

		const hashedPassword = await bcrypt.hash(registerDto.password, 10);
		const verificationToken = generateUUID7();
		const user = await this.userService.create({
			...registerDto,
			password: hashedPassword,
			isVerified: false,
			verificationToken
		});

		// Send verification email
		await this.emailService.sendVerificationEmail(
			user.email,
			verificationToken
		);

		return {
			message:
				'User registered. Please check your email for verification.'
		};
	}

	async saveRefreshAccessToken(userId: string, refreshToken: string) {
		await this.userService.updateRefreshToken(userId, refreshToken);
	}

	async login(loginDto: LoginDto) {
		const user = await this.userService.findByEmail(loginDto.email);
		if (!user) {
			throw new UnauthorizedException('Invalid credentials');
		}

		if (!user.isVerified) {
			throw new UnauthorizedException(
				'Please verify your email before logging in'
			);
		}

		const isPasswordValid = await bcrypt.compare(
			loginDto.password,
			user.password
		);
		if (!isPasswordValid) {
			throw new UnauthorizedException('Invalid credentials');
		}

		const generatedTokens = this.generateToken(user);

		await this.saveRefreshAccessToken(
			user.id,
			generatedTokens.refresh_token
		);

		return generatedTokens;
	}

	async refreshAccessToken(refreshToken: RefreshTokenDto) {
		try {
			const refresh_token = refreshToken.refresh_token;
			const payload = this.jwtService.verify(refresh_token);
			const user = await this.userService.findOne(payload.sub);

			if (!user || user.refreshToken == null) {
				throw new UnauthorizedException('Invalid refresh token');
			}

			const isRefreshTokenValid = await bcrypt.compare(
				refresh_token,
				user.refreshToken
			);

			if (!isRefreshTokenValid) {
				throw new UnauthorizedException('Invalid refresh token');
			}

			const newAccessToken = this.jwtService.sign(
				{ userId: user.id, email: user.email },
				{ expiresIn: '60m' }
			);
			return { accessToken: newAccessToken };
		} catch (e) {
			throw new UnauthorizedException(
				'Refresh token is invalid or expired'
			);
		}
	}

	async forgotPassword(forgotPasswordDto: ForgotPasswordDto) {
		const user = await this.userService.findByEmail(
			forgotPasswordDto.email
		);
		if (!user) {
			throw new NotFoundException('User not found');
		}

		const resetToken = generateUUID7();
		user.resetPasswordToken = resetToken;
		user.resetPasswordExpires = new Date(Date.now() + 3600000); // 1 hour from now
		await this.userService.save(user);

		// In a real application, send an email with the reset link
		// For now, we'll simulate this by calling our verification endpoint
		await this.emailService.sendForgotPasswordEmail(user.email, resetToken);

		return { message: 'Reset password instructions sent to email' };
	}

	async verifyResetPasswordToken(token: string) {
		const user = await this.userService.findByResetPasswordToken(token);
		if (!user) {
			throw new BadRequestException('Invalid password reset token');
		}

		if (
			!user.resetPasswordExpires ||
			user.resetPasswordExpires < new Date()
		) {
			throw new BadRequestException('Password reset token has expired');
		}

		return { message: 'Password reset token is valid' };
	}

	async resetPassword(resetPasswordDto: ResetPasswordDto) {
		const user = await this.userService.findByResetPasswordToken(
			resetPasswordDto.token
		);
		if (!user) {
			throw new BadRequestException(
				'Invalid or expired password reset token'
			);
		}

		if (
			!user.resetPasswordExpires ||
			user.resetPasswordExpires < new Date()
		) {
			throw new BadRequestException('Password reset token has expired');
		}

		user.password = await bcrypt.hash(resetPasswordDto.newPassword, 10);
		user.resetPasswordToken = null;
		user.resetPasswordExpires = null;
		await this.userService.save(user);

		return { message: 'Password has been reset successfully' };
	}

	private generateToken(user: any) {
		const payload = { email: user.email, sub: user.sub };
		return {
			access_token: this.jwtService.sign(payload, { expiresIn: '6d' }),
			refresh_token: this.jwtService.sign(payload, { expiresIn: '7d' })
		};
	}

	async verifyEmail(token: string) {
		const user = await this.userService.findByVerificationToken(token);
		if (!user) {
			throw new BadRequestException('Invalid verification token');
		}
		user.isVerified = true;
		user.verificationToken = null;
		await this.userService.save(user);
		return { message: 'Email verified successfully' };
	}

	async googleLogin(req: any) {
		if (!req.user) {
			return 'No user from google';
		}

		const existingUser = await this.userService.findByEmail(req.user.email);
		if (!existingUser) {
			const user = await this.userService.create({
				name: `${req.user.firstName || ''} ${req.user.lastName || ''}`,
				email: req.user.email,
				password: '',
				isVerified: true
			});
			const generatedTokens = this.generateToken({
				email: req.user.email,
				sub: user.id
			});
			await this.saveRefreshAccessToken(
				user.id,
				generatedTokens.refresh_token
			);
			return generatedTokens;
		}
		const generatedTokens = this.generateToken({
			email: req.user.email,
			sub: existingUser.id
		});

		await this.saveRefreshAccessToken(
			existingUser.id,
			generatedTokens.refresh_token
		);
		return generatedTokens;
	}

	async logout(token: string | null) {
		if (!token) {
			throw new UnauthorizedException('No token provided');
		}
		try {
			const payload = this.jwtService.decode(token) as any;
			this.jwtService.sign(
				{ email: payload.email, sub: payload.sub },
				{ expiresIn: '50ms' }
			);
			this.userService.clearRefreshToken(payload.sub);
			return {
				message: 'Logged out successfully'
			};
		} catch (error) {
			throw new BadRequestException('Logout failed');
		}
	}

	async emailLogin(loginEmailDto: LoginEmailDto) {
		const { email } = loginEmailDto;

		const user = await this.userService.findByEmail(email!);
		if (!user) {
			throw new NotFoundException('User not found');
		}

		const otp = generateOtp(6, true);
		const hashedOtp = await generateHash(otp);
		const otpExpiresAt = new Date();
		otpExpiresAt.setMinutes(otpExpiresAt.getMinutes() + 1);

		await this.authOtpRepository.createOtp(user, hashedOtp, otpExpiresAt);
		console.log(`Generated OTP for ${email}: ${otp}`);
		//TO-DO Email service
		const data = {
			name: user.name,
			email: user.email,
			otp: otp,
			expiry: '1'
		};
		await this.notificationService.send(
			[NotificationModeEnum.EMAIL],
			'customer-otp',
			data
		);
		return user;
	}

	async verifyOtp(verifyOtpDto: VerifyOtpDto) {
		const { email,phoneNumber, otp } = verifyOtpDto;
		let user;
		if (email) {
			user = await this.userService.findByEmail(email);
		} else if (phoneNumber) {
			user = await this.userService.findByPhoneNumber(phoneNumber);
		} else {
			throw new BadRequestException(
				this.i18nHelperService.t('errors.email_or_phone_required')
			);
		}
		if (!user) {
			throw new NotFoundException('User not found');
		}

		const latestOtp = await this.authOtpRepository.findByUserId(user.id);
		if (!latestOtp) {
			throw new BadRequestException(
				'No OTP found or it has already been used'
			);
		}

		const currentTime = new Date();
		if (latestOtp.expiresAt < currentTime) {
			throw new BadRequestException('OTP expired');
		}

		const isOtpValid = await bcrypt.compare(otp, latestOtp.otp);

		if (!isOtpValid) {
			throw new BadRequestException('Invalid OTP');
		}

		await this.authOtpRepository.remove(latestOtp);
		await this.removeExpiredOtps(user.id);
		user.isVerified = true;
		await this.userService.save(user);

		return this.generateToken({
			email: user.email,
			sub: user.id
		});
	}
	async removeExpiredOtps(userId: string): Promise<void> {
		const currentTime = new Date();
		const expiredOtps = await this.authOtpRepository.find({
			where: {
				user: { id: userId },
				expiresAt: LessThan(currentTime)
			}
		});
		if (expiredOtps.length > 0) {
			await this.authOtpRepository.remove(expiredOtps);
		}
	}
	private async sendOtp(user: User, type: NotificationModeEnum) {
		try {
			const otp = generateOtp(
				4,
				['test', 'dev', 'qa', 'uat'].includes(
					process.env.NODE_ENV || ''
				)
			);
			const hashedOtp = await generateHash(otp);
			const otpExpiresAt = new Date();
			otpExpiresAt.setMinutes(otpExpiresAt.getMinutes() + 10);

			await this.authOtpRepository.createOtp(
				user,
				hashedOtp,
				otpExpiresAt
			);
			const notificationType =
				type === NotificationModeEnum.EMAIL ? 'email' : 'phoneNumber';
			const data = {
				name: user.name,
				[notificationType]: user[notificationType],
				otp: otp,
				expiry: '10'
			};

			// TBD : Uncommeent once Gupshup is available
			// await this.notificationService.send(
			// 	[type],
			// 	'customer-otp',
			// 	data
			// );
		} catch (err) {
			throw new InternalServerErrorException(
				this.i18nHelperService.t('errors.otp_send_failed')
			);
		}
	}

	async phoneNumberLogin(phoneNumberLoginDto: PhoneNumberLoginDto) {
		const { phoneNumber, countryCode, language } = phoneNumberLoginDto;
	  
		let user = await this.userService.findByPhoneNumber(phoneNumber);
		let isNewUser = false;
	  
		if (!user) {
		  user = await this.userService.createUserByPhone({
			phoneNumber,
			countryCode,
			language,
		  });
		  isNewUser = true;
		} else {
		  if (language && user.language !== language) {
			await this.userService.updateUserLanguage(user.id, language);
		  }
		}
	  		await this.sendOtp(user, NotificationModeEnum.SMS);
	  
		return {
		  message: this.i18nHelperService.t('messages.otp_sent_success'),
		  isNewUser,
		};
	  }
}
