import { LoginEmailDto } from '@/auth/dto/login-email.dto';
import { VerifyOtpDto } from '@/auth/dto/verify-otp.dto';
import { Response } from '@/utils/response/decorators/response.decorator';
import { ApiErrorGenericResponse, ApiOkGenericResponse } from '@/utils/response/response.utils';
import {
	Body,
	Controller,
	Get,
	HttpCode,
	HttpStatus,
	Post,
	Query,
	Req,
	UseGuards
} from '@nestjs/common';
import { AuthGuard } from '@nestjs/passport';
import { ApiBody } from '@nestjs/swagger';
import { Request } from 'express';
import { AuthService } from './auth.service';
import { ForgotPasswordDto } from './dto/forgot-password.dto';
import { PhoneNumberLoginDto } from './dto/login-phone-number.dto';
import { LoginDto } from './dto/login.dto';
import { RefreshTokenDto } from './dto/refresh-token.dto';
import { RegisterDto } from './dto/register.dto';
import { ResetPasswordDto } from './dto/reset-password.dto';
import { OtpResponseDto, OtpSentResponseDto } from './dto/otp-response.dto';
@Controller('auth')
export class AuthController {
	constructor(private authService: AuthService) {}

	@Get('google')
	@UseGuards(AuthGuard('google'))
	async googleAuth() {}

	@Response('Successfully LoggedIn')
	@Get('redirect')
	@UseGuards(AuthGuard('google'))
	googleAuthRedirect(@Req() req: any) {
		return this.authService.googleLogin(req);
	}

	@Response('Registered Successfuly', RegisterDto)
	@Post('register')
	async register(@Body() registerDto: RegisterDto) {
		return this.authService.register(registerDto);
	}

	@Post('login')
	@HttpCode(HttpStatus.OK)
	async login(@Body() loginDto: LoginDto) {
		return this.authService.login(loginDto);
	}

	@Response('OTP sent to email', LoginEmailDto)
	@Post('login/email')
	async loginEmail(@Body() loginEmailDto: LoginEmailDto) {
		return this.authService.emailLogin(loginEmailDto);
	}
	@ApiBody({
		type: PhoneNumberLoginDto,
	  })
	  @ApiErrorGenericResponse('Failed to send OTP')
	  @ApiOkGenericResponse(OtpSentResponseDto, 'OTP sent to phone number')
	  @Post('login/phone-number')
	  async loginPhoneNumber(@Body() loginPhoneNumberDto: PhoneNumberLoginDto) {

		return this.authService.phoneNumberLogin(loginPhoneNumberDto);
	  }

	  @ApiBody({
		type: VerifyOtpDto
	})
	// @Response('LoggedIn successfully')
	@ApiErrorGenericResponse('Failed to login user')
	@ApiOkGenericResponse(OtpResponseDto, 'User logged in successfully')
	@Post('verify-otp')
	async verifyOtp(@Body() verifyOtpDto: VerifyOtpDto) {
		return this.authService.verifyOtp(verifyOtpDto);
	}

	@Post('verify-email')
	async verifyEmail(@Query('token') token: string) {
		return this.authService.verifyEmail(token);
	}

	@Post('forgot-password')
	async forgotPassword(@Body() forgotPasswordDto: ForgotPasswordDto) {
		return this.authService.forgotPassword(forgotPasswordDto);
	}

	@Post('verify-reset-password')
	async verifyResetPasswordToken(@Query('token') token: string) {
		return this.authService.verifyResetPasswordToken(token);
	}

	@Post('reset-password')
	async resetPassword(@Body() resetPasswordDto: ResetPasswordDto) {
		return this.authService.resetPassword(resetPasswordDto);
	}

	@Post('logout')
	async logout(@Req() req: Request) {
		const accessToken = req.headers.authorization?.split(' ')[1] ?? null;
		return await this.authService.logout(accessToken);
	}

	@Post('refresh-token')
	async refreshToken(@Body() refreshTokenDto: RefreshTokenDto) {
		return this.authService.refreshAccessToken(refreshTokenDto);
	}
}
