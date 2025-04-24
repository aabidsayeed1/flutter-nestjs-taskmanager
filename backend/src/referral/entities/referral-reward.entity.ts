import { BaseEntity } from '@/base/entities/base.entity';
import { User } from '@/user/entities/user.entity';
import { Column, Entity, JoinColumn, OneToOne } from 'typeorm';

@Entity()
export class ReferralReward extends BaseEntity {
	@OneToOne(() => User, user => user.referralReward)
	@JoinColumn()
	user!: User;

	@Column({ default: 0 })
	reward!: number;

	@Column({ type: 'timestamp', nullable: true })
	rewardsExpiry!: Date | null;
}
