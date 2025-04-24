import { Module } from '@nestjs/common';
//import { APP_INTERCEPTOR } from '@nestjs/core';

@Module({
	providers: [
		// {
		// 	provide: APP_INTERCEPTOR,
		// 	useClass: ResponseInterceptor
		// }
	],
	exports: []
})
export class ResponseModule {}
