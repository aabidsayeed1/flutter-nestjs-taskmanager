import { PrimaryColumn } from 'typeorm';
import { uuidv7 } from 'uuidv7';

export function PrimaryUUID7Column(
	options: Partial<{ name: string }> = {}
): PropertyDecorator {
	return PrimaryColumn('uuid', {
		name: options.name || 'id',
		default: () => `'${generateUUID7()}'`
	});
}

export function generateUUID7(): string {
	return uuidv7();
}
