import { AuthOTP } from '@/auth/entities/authOtp.entity';
import { User } from '@/user/entities/user.entity';
import { Injectable } from '@nestjs/common';
import { DataSource, Repository } from 'typeorm';

@Injectable()
export class AuthOtpRepository extends Repository<AuthOTP> {
	constructor(dataSource: DataSource) {
		super(AuthOTP, dataSource.manager);
	}

	async createOtp(
		user: User,
		otp: string,
		expiresAt: Date
	): Promise<AuthOTP> {
		const otpEntity = this.create({
			otp,
			expiresAt,
			user
		});
		return this.save(otpEntity);
	}

	async findByUserId(userId: string): Promise<AuthOTP | null> {
		return this.findOne({
			where: { user: { id: userId } },
			order: { createdAt: 'DESC' }
		});
	}
}
