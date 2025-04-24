import { Entity, Column, OneToOne, JoinColumn, OneToMany } from 'typeorm';
import { User } from '@/user/entities/user.entity';
import { BaseEntity } from '@/base/entities/base.entity';
import { ReferralUsage } from './referral-usage.entity';

@Entity()
export class Referral extends BaseEntity {
	@Column({ unique: true })
	code!: string;

	@OneToOne(() => User)
	@JoinColumn()
	user!: User;

	@Column({ nullable: true })
	referralUrl!: string;

	@OneToMany(() => User, user => user.referrer)
	referredUsers!: User[];

	@Column({ type: 'timestamp', nullable: true })
	rewardsExpiry!: Date | null;

	@OneToMany(() => ReferralUsage, referralUsage => referralUsage.referral)
	referralUsages!: ReferralUsage[];
}
