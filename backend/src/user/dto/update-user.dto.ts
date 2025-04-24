import { IsOptional, IsString, MaxLength, MinLength } from 'class-validator';

export class UpdateUserDto {
	@IsString()
	@MinLength(2)
	@MaxLength(50)
	name!: string;

	@IsString()
	@IsOptional()
	profilePicture!: string;
}
