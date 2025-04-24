import {
	CUSTOM_RESPONSE_DTO_KEY,
	CUSTOM_RESPONSE_KEY
} from '@/utils/response/constants/response.constant';
import { ResponseInterceptor } from '@/utils/response/interceptors/response.interceptor';
import { applyDecorators, SetMetadata, UseInterceptors } from '@nestjs/common';

export const Response = (message: string, dto?: any) => {
	const decorators = [
		SetMetadata(CUSTOM_RESPONSE_KEY, message),
		dto && SetMetadata(CUSTOM_RESPONSE_DTO_KEY, dto), // Only include if dto is provided
		UseInterceptors(ResponseInterceptor)
	].filter(Boolean); // Remove any undefined values
	return applyDecorators(...decorators);
};
