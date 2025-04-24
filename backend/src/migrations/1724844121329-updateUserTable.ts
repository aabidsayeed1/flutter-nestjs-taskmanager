// import { MigrationInterface, QueryRunner, TableColumn } from 'typeorm';

// export class AddProfilePictureToUsers1724844121329
// 	implements MigrationInterface
// {
// 	public async up(queryRunner: QueryRunner): Promise<void> {
// 		await queryRunner.addColumn(
// 			'users',
// 			new TableColumn({
// 				name: 'profilePicture',
// 				type: 'varchar',
// 				isNullable: true
// 			})
// 		);
// 	}

// 	public async down(queryRunner: QueryRunner): Promise<void> {
// 		await queryRunner.dropColumn('users', 'profilePicture');
// 	}
// }
