import {
	ValidationArguments,
	ValidatorConstraint,
	ValidatorConstraintInterface
} from 'class-validator';
import parsePhoneNumberFromString, {
	isValidPhoneNumber
} from 'libphonenumber-js';

@ValidatorConstraint({ name: 'PhoneNumberValidator', async: false })
export class PhoneNumberValidator implements ValidatorConstraintInterface {
	validate(
		phoneNumber: string,
		validationArguments: ValidationArguments
	): boolean {
		const { countryCode } = validationArguments.object as any;
		try {
			const all = countryCode + phoneNumber;
			const isValid = isValidPhoneNumber(all);
			return isValid;
		} catch (error) {
			return false;
		}
	}
	defaultMessage(validationArguments?: ValidationArguments): string {
		return `Phone number is not valid for the country code (${validationArguments?.constraints[0]})`;
	}
}
