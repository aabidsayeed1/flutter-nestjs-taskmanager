// import { MigrationInterface, QueryRunner, TableColumn } from 'typeorm';

// export class AddLanguageInUsers1743743603775 implements MigrationInterface {
// 	name = 'AddLanguageInUsers1743743603775';

// 	public async up(queryRunner: QueryRunner): Promise<void> {
// 		await queryRunner.addColumn(
// 			'users',
// 			new TableColumn({
// 				name: 'language',
// 				type: 'varchar',
// 				length: '10',
// 				isNullable: true,
// 				default: "'en'"
// 			})
// 		);
// 	}

// 	public async down(queryRunner: QueryRunner): Promise<void> {
// 		await queryRunner.dropColumn('users', 'language');
// 	}
// }
