import { Feedback, FeedbackType } from '@/feedback/entities/feedback.entity';
import { User } from '@/user/entities/user.entity';
import { faker } from '@faker-js/faker';

// function to get a random enum value
export function getRandomEnumValue<T extends Record<string, any>>(
	enumObject: T
): T[keyof T] {
	// Ensure that the enumObject is an object with enumerable properties
	const enumValues = Object.values(enumObject) as T[keyof T][];

	if (enumValues.length === 0) {
		throw new Error('Enum has no values');
	}

	const randomIndex = Math.floor(Math.random() * enumValues.length);
	return enumValues[randomIndex];
}

//creating a fake feedback instance
export const mockFeedback: Feedback = {
	id: faker.string.uuid(),
	user: {
		id: faker.string.uuid(),
		name: faker.person.firstName(),
		email: faker.internet.email()
	} as User,
	type: getRandomEnumValue(FeedbackType),
	message: faker.lorem.sentence(),
	createdAt: faker.date.recent(),
	updatedAt: faker.date.recent(),
	deletedAt: null
};

// Copy mockFeedback into mockFeedbackGroup
export const mockFeedbackGroup = [
	{
		user: {
			id: mockFeedback.user.id,
			name: mockFeedback.user.name,
			email: mockFeedback.user.email
		},
		feedbacks: [
			{
				id: mockFeedback.id,
				type: mockFeedback.type,
				message: mockFeedback.message,
				createdAt: mockFeedback.createdAt,
				updatedAt: mockFeedback.updatedAt,
				deletedAt: mockFeedback.deletedAt
			}
		]
	}
];
