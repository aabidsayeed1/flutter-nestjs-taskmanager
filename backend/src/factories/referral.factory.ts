import { ReferralUsage } from '@/referral/entities/referral-usage.entity';
import { Referral } from '@/referral/entities/referral.entity';
import { User } from '@/user/entities/user.entity';
import { faker } from '@faker-js/faker';

export const mockReferral: Referral = {
	id: faker.string.uuid(),
	code: faker.string.alphanumeric(8),
	user: {
		id: faker.string.uuid(),
		name: faker.person.firstName(),
		email: faker.internet.email()
	} as User,
	referralUrl: `https://myapp.com/ref/${faker.string.alphanumeric(8)}`,
	referredUsers: [
		{
			id: faker.string.uuid(),
			name: faker.person.firstName(),
			email: faker.internet.email()
		} as User
	],
	rewardsExpiry: faker.date.future(),
	referralUsages: [
		{
			id: faker.string.uuid(),
			usageDate: faker.date.recent()
		} as unknown as ReferralUsage
	],
	createdAt: faker.date.recent(),
	updatedAt: faker.date.recent(),
	deletedAt: null
};
