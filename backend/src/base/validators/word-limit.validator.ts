import {
	ValidatorConstraint,
	ValidatorConstraintInterface,
	ValidationArguments,
	Validate,
	ValidationOptions
} from 'class-validator';

export function IsWordLimit(
	maxWords: number,
	validationOptions?: ValidationOptions
) {
	return function (object: any, propertyName: string) {
		Validate(
			IsWordLimitConstraint,
			[maxWords],
			validationOptions
		)(object, propertyName);
	};
}

@ValidatorConstraint({ async: false })
class IsWordLimitConstraint implements ValidatorConstraintInterface {
	validate(text: string, args: ValidationArguments) {
		const [maxWords] = args.constraints;
		const wordCount = text.trim().split(/\s+/).length;
		return wordCount <= maxWords;
	}

	defaultMessage(args: ValidationArguments) {
		const [maxWords] = args.constraints;
		return `Message must not exceed ${maxWords} words`;
	}
}
