import { ApiProperty } from '@nestjs/swagger';

export class OtpResponseDto {
	@ApiProperty({
		name: 'access_token',
		description: 'Access token for the user'
	})
	access_token?: string;
	@ApiProperty({
		name: 'refresh_token',
		description: 'Refresh token for the user'
	})
	refresh_token?: string;
}

export class OtpSentResponseDto {
	@ApiProperty({
		name: 'message',
		description: 'OTP sent successfully'
	})
	message?: string;
	@ApiProperty({
		name: 'isNewUser',
		description: 'Tells if its a first login or not'
	})
	isNewUser?: boolean;
}
