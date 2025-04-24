export interface INotificationProvider {
	sendNotification(
		to: string,
		message: string,
		subject?: string
	): Promise<void>;
}
