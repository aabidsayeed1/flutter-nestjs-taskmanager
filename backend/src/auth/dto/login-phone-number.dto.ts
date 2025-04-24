import { PhoneNumberValidator } from '@/utils/phone-number.validator';
import { ApiProperty } from '@nestjs/swagger';
import { IsNotEmpty, IsOptional, IsString, Validate } from 'class-validator';
export class PhoneNumberLoginDto {
	@ApiProperty({
		example: '+91'
	})
	@IsNotEmpty()
	@IsString()
	countryCode!: string;

	@ApiProperty({
		example: '9988999890'
	})
	@IsNotEmpty()
	@IsString()
	@Validate(PhoneNumberValidator, ['countryCode'])
	phoneNumber!: string;
	@IsOptional()
	language?: string | null;
}