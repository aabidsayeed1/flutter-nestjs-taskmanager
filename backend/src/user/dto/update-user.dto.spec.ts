import { plainToInstance } from 'class-transformer';
import { validate } from 'class-validator';
import { UpdateUserDto } from './update-user.dto';

describe('UpdateUserDto', () => {
	it('should validate a correct DTO object', async () => {
		const dto = plainToInstance(UpdateUserDto, {
			name: 'John Doe',
			profilePicture: 'http://example.com/pic.jpg'
		});
		const errors = await validate(dto);

		expect(errors.length).toBe(0);
	});

	it('should fail validation if name is too short', async () => {
		const dto = plainToInstance(UpdateUserDto, { name: 'J' });
		const errors = await validate(dto);

		expect(errors.length).toBeGreaterThan(0);
		expect(errors[0].constraints).toHaveProperty('minLength');
	});

	it('should fail validation if name is too long', async () => {
		const longName = 'a'.repeat(51);
		const dto = plainToInstance(UpdateUserDto, { name: longName });
		const errors = await validate(dto);

		expect(errors.length).toBeGreaterThan(0);
		expect(errors[0].constraints).toHaveProperty('maxLength');
	});

	it('should fail validation if profilePicture is not a string', async () => {
		const dto = plainToInstance(UpdateUserDto, {
			name: 'John Doe',
			profilePicture: 12345
		});
		const errors = await validate(dto);

		expect(errors.length).toBeGreaterThan(0);
		expect(errors[0].constraints).toHaveProperty('isString');
	});

	it('should pass validation if profilePicture is optional and not provided', async () => {
		const dto = plainToInstance(UpdateUserDto, { name: 'John Doe' });
		const errors = await validate(dto);

		expect(errors.length).toBe(0);
	});
});
