import * as bcrypt from 'bcrypt';
import * as crypto from 'crypto';

export function generateOtp(size: number, isDefault: boolean): string {
	if (isDefault) {
		return '123456'.slice(0, size);
	}
	const min = Math.pow(10, size - 1); // Minimum value for the desired OTP size
	const max = Math.pow(10, size) - 1; // Maximum value for the desired OTP size
	return crypto.randomInt(min, max).toString();
}

export const generateHash = async (value: string): Promise<string> => {
	const salt = await bcrypt.genSalt(10);
	return bcrypt.hash(value, salt);
};
