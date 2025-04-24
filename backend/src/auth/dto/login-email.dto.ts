import { Expose } from 'class-transformer';
import { IsEmail, IsNotEmpty } from 'class-validator';

export class LoginEmailDto {
	@IsEmail()
	@IsNotEmpty()
	@Expose()
	email: string | undefined;
}
