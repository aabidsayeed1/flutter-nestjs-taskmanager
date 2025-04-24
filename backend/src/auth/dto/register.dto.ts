import { IsEmail, IsString, MaxLength, MinLength } from 'class-validator';

export class RegisterDto {
	@IsString()
	@MinLength(2)
	@MaxLength(50)
	name!: string;

	@IsEmail()
	email!: string;

	// Add a regex according to password rules
	@IsString()
	@MinLength(8)
	@MaxLength(32)
	password!: string;
}
