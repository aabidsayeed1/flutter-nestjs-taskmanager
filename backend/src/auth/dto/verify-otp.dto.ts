import { ApiProperty } from '@nestjs/swagger';
import { IsEmail, IsNotEmpty, IsOptional, ValidateIf } from 'class-validator';

export class VerifyOtpDto {
	@ApiProperty({
		example: 'example@gmail.com'
	})
	@ValidateIf(o => !o.phoneNumber) // Only validate email if phoneNumber is not present
	@IsNotEmpty({ message: 'Either phone number or email is required.' })
	@IsEmail()
	@IsOptional()
	email?: string;

	@ApiProperty({
		example: '8989898989'
	})
	@ValidateIf(o => !o.email) // Only validate phoneNumber if email is not present
	@IsNotEmpty({ message: 'Either phone number or email is required.' })
	@IsOptional()
	phoneNumber?: string;

	@ApiProperty({
		example: '4576'
	})
	@IsNotEmpty()
	otp!: string;
}
