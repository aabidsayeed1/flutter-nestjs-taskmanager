export class ValidateResponseReferralCodeDTO {
	id!: string;
	code!: string;
	user!: {
		id: string;
		name: string;
		email: string;
	};
}
