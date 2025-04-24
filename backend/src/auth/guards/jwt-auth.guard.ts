import { Injectable } from '@nestjs/common';
import { AuthGuard } from '@nestjs/passport';

@Injectable()
export class JwtAuthGuard extends AuthGuard('jwt') {
	constructor() {
		super();
	}
}

// Helper function for testing
export const createJwtAuthGuard = () => {
	return new JwtAuthGuard();
};
