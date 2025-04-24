import { BaseEntity } from '@/base/entities/base.entity';
import { User } from '@/user/entities/user.entity';
import { Column, Entity, JoinColumn, ManyToOne } from 'typeorm';

@Entity('authOtps')
export class AuthOTP extends BaseEntity {
	@Column({ type: 'varchar', length: 255 })
	otp!: string;

	@Column({ type: 'timestamp' })
	expiresAt!: Date;

	@ManyToOne(() => User, user => user.authOtp, { onDelete: 'CASCADE' })
	@JoinColumn({ name: 'userId' })
	user!: User;
}
