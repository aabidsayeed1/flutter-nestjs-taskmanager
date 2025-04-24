import { IsEmail, IsString } from 'class-validator';

export class LoginDto {
	@IsEmail()
	email!: string;

	// Add a regex according to password rules
	@IsString()
	password!: string;
}
