import {
	IsBoolean,
	IsEmail,
	IsOptional,
	IsString,
	MaxLength,
	MinLength
} from 'class-validator';

export class CreateUserDto {
	@IsString()
	@MinLength(2)
	@MaxLength(50)
	name!: string;

	@IsEmail()
	email!: string;

	@IsString()
	@MinLength(8)
	@MaxLength(32)
	password!: string;

	@IsBoolean()
	@IsOptional()
	isVerified?: boolean;

	@IsString()
	@IsOptional()
	verificationToken?: string | null;
}
