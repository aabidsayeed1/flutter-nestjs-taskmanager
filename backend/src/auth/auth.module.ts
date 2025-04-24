import { AuthOtpRepository } from '@/auth/authOtp.repository';
import { Module } from '@nestjs/common';
import { JwtModule } from '@nestjs/jwt';
import { PassportModule } from '@nestjs/passport';
import { UserModule } from '../user/user.module';
import { AuthController } from './auth.controller';
import { AuthService } from './auth.service';
import { EmailService } from './email/email.service';
import { GoogleStrategy } from './strategy/google.strategy';
import { NotificationsModule } from '@/notifications/notifications.module';

@Module({
	imports: [
		UserModule,
		PassportModule,
		JwtModule.register({
			secret: 'your_jwt_secret', // Use environment variables in production
			signOptions: { expiresIn: '60m' }
		}),
		NotificationsModule
	],
	controllers: [AuthController],
	providers: [AuthService, EmailService, GoogleStrategy, AuthOtpRepository],
	exports: [AuthService]
})
export class AuthModule {}
