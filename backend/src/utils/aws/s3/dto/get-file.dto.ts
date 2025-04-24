import { IsNotEmpty, IsString } from 'class-validator';

export class GetFileDto {
	@IsString()
	@IsNotEmpty()
	key!: string;
}
