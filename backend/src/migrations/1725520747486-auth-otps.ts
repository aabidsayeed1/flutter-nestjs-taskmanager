// import { MigrationInterface, QueryRunner } from "typeorm";

// export class AuthOtps1725520747486 implements MigrationInterface {
//     name = 'AuthOtps1725520747486'

//     public async up(queryRunner: QueryRunner): Promise<void> {
//         await queryRunner.query(`CREATE TABLE "authOtps" ("id" uuid NOT NULL DEFAULT uuid_generate_v4(), "createdAt" TIMESTAMP NOT NULL DEFAULT now(), "updatedAt" TIMESTAMP NOT NULL DEFAULT now(), "deletedAt" TIMESTAMP, "otp" character varying(255) NOT NULL, "expiresAt" TIMESTAMP NOT NULL, "userId" uuid, CONSTRAINT "PK_c2ecdd970e00b7dee207576900a" PRIMARY KEY ("id"))`);
//         await queryRunner.query(`ALTER TABLE "authOtps" ADD CONSTRAINT "FK_614b3599dc900b54c6244ea1017" FOREIGN KEY ("userId") REFERENCES "users"("id") ON DELETE CASCADE ON UPDATE NO ACTION`);
//     }

//     public async down(queryRunner: QueryRunner): Promise<void> {
//         await queryRunner.query(`ALTER TABLE "authOtps" DROP CONSTRAINT "FK_614b3599dc900b54c6244ea1017"`);
//         await queryRunner.query(`DROP TABLE "authOtps"`);
//     }

// }
