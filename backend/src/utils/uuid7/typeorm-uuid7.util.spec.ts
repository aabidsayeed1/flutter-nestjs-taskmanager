import { PrimaryUUID7Column } from './typeorm-uuid7.utils';
import * as TypeORM from 'typeorm';
import { uuidv7 } from 'uuidv7';

jest.mock('typeorm');
jest.mock('uuidv7');

describe('typeorm-uuid7.util', () => {
	describe('PrimaryUUID7Column', () => {
		beforeEach(() => {
			jest.clearAllMocks();
			(uuidv7 as jest.Mock).mockReturnValue('mocked-uuid');
		});

		it('should create a PrimaryColumn with default options', () => {
			const mockPrimaryColumn = jest
				.spyOn(TypeORM, 'PrimaryColumn')
				.mockReturnValue(() => {});

			class TestEntity {
				@PrimaryUUID7Column()
				id!: string;
			}

			expect(TestEntity).toBeDefined();

			expect(mockPrimaryColumn).toHaveBeenCalledWith('uuid', {
				name: 'id',
				default: expect.any(Function)
			});

			const defaultFunction =
				mockPrimaryColumn.mock.calls[0]?.[1]?.default;
			if (typeof defaultFunction === 'function') {
				const result = defaultFunction();
				expect(uuidv7).toHaveBeenCalled();
				expect(result).toBe("'mocked-uuid'");
			} else {
				fail('Default function is not defined');
			}
		});

		it('should create a PrimaryColumn with custom name', () => {
			const mockPrimaryColumn = jest
				.spyOn(TypeORM, 'PrimaryColumn')
				.mockReturnValue(() => {});

			class TestEntity {
				@PrimaryUUID7Column({ name: 'custom_id' })
				id!: string;
			}

			const entityInstance: TestEntity = {} as TestEntity;
			expect(entityInstance).toBeDefined();

			expect(mockPrimaryColumn).toHaveBeenCalledWith('uuid', {
				name: 'custom_id',
				default: expect.any(Function)
			});

			const defaultFunction =
				mockPrimaryColumn.mock.calls[0]?.[1]?.default;
			if (typeof defaultFunction === 'function') {
				const result = defaultFunction();
				expect(uuidv7).toHaveBeenCalled();
				expect(result).toBe("'mocked-uuid'");
			} else {
				fail('Default function is not defined');
			}
		});
	});
});
