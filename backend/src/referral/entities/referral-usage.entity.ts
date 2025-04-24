import { BaseEntity } from '@/base/entities/base.entity';
import { User } from '@/user/entities/user.entity';
import { Column, Entity, JoinColumn, ManyToOne } from 'typeorm';
import { Referral } from './referral.entity';

@Entity()
export class ReferralUsage extends BaseEntity {
	@ManyToOne(() => User, user => user.referralUsages)
	@JoinColumn({ name: 'userId' })
	user!: User;

	@ManyToOne(() => Referral, referral => referral.referralUsages)
	@JoinColumn({ name: 'referralId' })
	referral!: Referral;

	@Column({ default: 0 })
	reward!: number;
}
