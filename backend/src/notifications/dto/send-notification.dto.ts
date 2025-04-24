import { IsEnum, IsNotEmpty, IsOptional, IsString } from 'class-validator';
import { NotificationModeEnum } from '../enums/notification-mode.enum';
import { ProviderTypeEnum } from '../enums/provider-type.enum';

export class SendNotificationDto {
	@IsEnum(NotificationModeEnum)
	@IsNotEmpty()
	mode!: NotificationModeEnum;

	@IsEnum(ProviderTypeEnum)
	@IsNotEmpty()
	provider!: ProviderTypeEnum;

	@IsString()
	@IsNotEmpty()
	recipient!: string;

	@IsString()
	@IsNotEmpty()
	messageKey!: string;

	@IsString()
	@IsOptional()
	subjectKey?: string;

	@IsString()
	@IsOptional()
	lang?: string;

	@IsNotEmpty()
	payload?: {
		[key: string]: any;
	};
}
