export interface IMessageHelperProvider {
	send(): Promise<void>;
}
