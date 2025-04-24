import { Expose } from 'class-transformer';

export class FindUserDto {
	@Expose()
	name!: string;

	@Expose()
	email!: string;
}
