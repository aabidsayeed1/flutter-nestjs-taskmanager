import { ReferralReward } from '@/referral/entities/referral-reward.entity';
import { Referral } from '@/referral/entities/referral.entity';
import { User } from '@/user/entities/user.entity';
import { faker } from '@faker-js/faker';

export const createUser = async (): Promise<User> => {
	const user = new User();
	user.id = faker.string.uuid();
	user.name = faker.person.firstName();
	user.email = faker.internet.email();
	user.password = faker.internet.password();
	user.isVerified = faker.datatype.boolean();
	user.verificationToken = faker.string.alphanumeric(10);
	user.resetPasswordToken = faker.string.alphanumeric(10);
	user.resetPasswordExpires = faker.date.future();
	user.profilePicture = faker.image.avatar();
	user.createdAt = faker.date.recent();
	user.updatedAt = faker.date.recent();
	user.feedback = [];
	user.referrer = new Referral();
	user.referralUsages = [];
	user.referralReward = new ReferralReward();
	user.authOtp = [];
	user.refreshToken = faker.string.alphanumeric(10);
	return user;
};

export const mockUser: User = {
	id: faker.string.uuid(),
	name: faker.person.firstName(),
	email: faker.internet.email(),
	password: faker.internet.password(),
	refreshToken: faker.string.alphanumeric(10),
	isVerified: faker.datatype.boolean(),
	verificationToken: null,
	resetPasswordToken: null,
	resetPasswordExpires: null,
	profilePicture: faker.image.avatar(),
	deletedAt: null,
	createdAt: faker.date.recent(),
	updatedAt: faker.date.recent(),
	feedback: [],
	authOtp: [],
	referrer: new Referral(),
	referralUsages: [],
	referralReward: new ReferralReward(),
	language: 'en',
	phoneNumber: '',
	countryCode: ''
};
