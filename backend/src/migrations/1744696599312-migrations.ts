import { MigrationInterface, QueryRunner } from "typeorm";

export class Migrations1744696599312 implements MigrationInterface {
    name = 'Migrations1744696599312'

    public async up(queryRunner: QueryRunner): Promise<void> {
        await queryRunner.query(`ALTER TABLE "task" ADD "isOffline" boolean NOT NULL DEFAULT false`);
    }

    public async down(queryRunner: QueryRunner): Promise<void> {
        await queryRunner.query(`ALTER TABLE "task" DROP COLUMN "isOffline"`);
    }

}
