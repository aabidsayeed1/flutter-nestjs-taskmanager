// import { MigrationInterface, QueryRunner } from "typeorm";

// export class UpdateUserType1726739042113 implements MigrationInterface {
//     name = 'UpdateUserType1726739042113'

//     public async up(queryRunner: QueryRunner): Promise<void> {
//         await queryRunner.query(`ALTER TABLE "users" ADD "refreshToken" character varying`);
//     }

//     public async down(queryRunner: QueryRunner): Promise<void> {
//         await queryRunner.query(`ALTER TABLE "users" DROP COLUMN "refreshToken"`);
//     }

// }
