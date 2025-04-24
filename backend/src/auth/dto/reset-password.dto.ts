import { IsString, MinLength, MaxLength } from 'class-validator';

export class ResetPasswordDto {
	@IsString()
	token!: string;

	// Add a regex according to password rules
	@IsString()
	@MinLength(8)
	@MaxLength(32)
	newPassword!: string;
}
