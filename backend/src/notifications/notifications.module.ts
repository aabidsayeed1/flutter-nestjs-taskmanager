import { Module } from '@nestjs/common';
import { GupshupSmsProvider } from './providers/gupshup-sms.provider';
import { KaleyraSmsProvider } from './providers/kaleyra-sms.provider';
import { MailgunEmailProvider } from './providers/mailgun-email.provider';
import { NodemailerEmailProvider } from './providers/nodemailer-email.provider';
import { NotificationService } from './services/notification.service';

@Module({
	providers: [
		NotificationService,
		{ provide: 'GupshupSmsProvider', useClass: GupshupSmsProvider },
		{ provide: 'KaleyraSmsProvider', useClass: KaleyraSmsProvider },
		{
			provide: 'NodemailerEmailProvider',
			useClass: NodemailerEmailProvider
		},
		{ provide: 'MailgunEmailProvider', useClass: MailgunEmailProvider }
	],
	exports: [NotificationService]
})
export class NotificationsModule {}
