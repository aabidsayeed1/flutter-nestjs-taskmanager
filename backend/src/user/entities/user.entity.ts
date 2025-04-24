import { AuthOTP } from '@/auth/entities/authOtp.entity';
import { BaseEntity } from '@/base/entities/base.entity';
import { Feedback } from '@/feedback/entities/feedback.entity';
import { ReferralReward } from '@/referral/entities/referral-reward.entity';
import { ReferralUsage } from '@/referral/entities/referral-usage.entity';
import { Referral } from '@/referral/entities/referral.entity';
import {
	Column,
	Entity,
	JoinColumn,
	ManyToOne,
	OneToMany,
	OneToOne
} from 'typeorm';

@Entity('users')
export class User extends BaseEntity {
	@Column({ nullable: true })
	name!: string;

	@Column({ unique: true, nullable: true })
	email!: string;

	@Column({nullable: true})
	password!: string;

	@Column({ default: false })
	isVerified!: boolean;
	@Column({ type: 'varchar', nullable: true })
	verificationToken!: string | null;

	@Column({ type: 'varchar', nullable: true })
	resetPasswordToken!: string | null;

	@Column({ type: 'timestamp', nullable: true })
	resetPasswordExpires!: Date | null;

	@Column({ type: 'varchar', nullable: true })
	refreshToken!: string | null;

	@OneToMany(() => Feedback, feedback => feedback.user)
	feedback!: Feedback[];

	@OneToMany(() => AuthOTP, authOtp => authOtp.user)
	authOtp!: AuthOTP[];

	@Column({ type: 'varchar', nullable: true })
	profilePicture!: string | null;

	@ManyToOne(() => Referral, referral => referral.referredUsers)
	referrer!: Referral;

	@OneToMany(() => ReferralUsage, referralUsage => referralUsage.user)
	referralUsages!: ReferralUsage[];

	@OneToOne(() => ReferralReward, referralReward => referralReward.user)
	@JoinColumn()
	referralReward!: ReferralReward;

	@Column({type: 'varchar', nullable: true, default: 'en' })
	language!: string | null;

	@Column({ nullable: true,  unique: true  })
	phoneNumber!: string;

	@Column({ name: 'country_code', type: 'varchar',nullable: true })
	countryCode!: string;
}
