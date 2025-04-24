import { ApiProperty } from '@nestjs/swagger';

export class ResponseDto<T> {
	@ApiProperty()
	success!: boolean;

	@ApiProperty()
	message!: string;

	@ApiProperty({ type: 'object', nullable: true })
	entity?: T | null;

	@ApiProperty({ required: false, nullable: true })
	errorResponse?: any;

	@ApiProperty({ required: false, example: 200 })
	statusCode!: number;
}
