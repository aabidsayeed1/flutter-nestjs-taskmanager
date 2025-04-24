import {
	IsBoolean,
	IsEmail,
	IsOptional,
	IsString,
	MaxLength,
	MinLength,
} from 'class-validator';


export class CreateUserByPhoneDto {
	@IsString()
	@MinLength(2)
	@MaxLength(50)
	@IsOptional()
	name?: string;

	@IsEmail()
	@IsOptional()
	email?: string;

	@IsString()
	@MinLength(8)
	@MaxLength(32)
	@IsOptional()
	password?: string;

	@IsBoolean()
	@IsOptional()
	isVerified?: boolean;

	@IsString()
	@IsOptional()
	verificationToken?: string | null;

	@IsString()
	phoneNumber!: string;

	@IsString()
	countryCode!: string;

	@IsOptional()
	@IsString()
	language?: string | null;
}
