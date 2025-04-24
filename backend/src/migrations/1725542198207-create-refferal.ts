// import { MigrationInterface, QueryRunner } from "typeorm";

// export class CreateRefferal1725542198207 implements MigrationInterface {
//     name = 'CreateRefferal1725542198207'

//     public async up(queryRunner: QueryRunner): Promise<void> {
//         await queryRunner.query(`CREATE TABLE "referral_usage" ("id" uuid NOT NULL DEFAULT uuid_generate_v4(), "createdAt" TIMESTAMP NOT NULL DEFAULT now(), "updatedAt" TIMESTAMP NOT NULL DEFAULT now(), "deletedAt" TIMESTAMP, "reward" integer NOT NULL DEFAULT '0', "userId" uuid, "referralId" uuid, CONSTRAINT "PK_2bef68c3bcec1ec368ee7c6fbc5" PRIMARY KEY ("id"))`);
//         await queryRunner.query(`CREATE TABLE "referral" ("id" uuid NOT NULL DEFAULT uuid_generate_v4(), "createdAt" TIMESTAMP NOT NULL DEFAULT now(), "updatedAt" TIMESTAMP NOT NULL DEFAULT now(), "deletedAt" TIMESTAMP, "code" character varying NOT NULL, "referralUrl" character varying, "rewardsExpiry" TIMESTAMP, "userId" uuid, CONSTRAINT "UQ_614bc7bce772214a17518410eab" UNIQUE ("code"), CONSTRAINT "REL_1fbffba89b7ed9ca14a5b75024" UNIQUE ("userId"), CONSTRAINT "PK_a2d3e935a6591168066defec5ad" PRIMARY KEY ("id"))`);
//         await queryRunner.query(`CREATE TABLE "referral_reward" ("id" uuid NOT NULL DEFAULT uuid_generate_v4(), "createdAt" TIMESTAMP NOT NULL DEFAULT now(), "updatedAt" TIMESTAMP NOT NULL DEFAULT now(), "deletedAt" TIMESTAMP, "reward" integer NOT NULL DEFAULT '0', "rewardsExpiry" TIMESTAMP, "userId" uuid, CONSTRAINT "REL_2ffef22fc829d68eb69e9be8cb" UNIQUE ("userId"), CONSTRAINT "PK_039e9361b7ea8c9a9e500ee6e1e" PRIMARY KEY ("id"))`);
//         await queryRunner.query(`ALTER TABLE "users" ADD "referrerId" uuid`);
//         await queryRunner.query(`ALTER TABLE "users" ADD "referralRewardId" uuid`);
//         await queryRunner.query(`ALTER TABLE "users" ADD CONSTRAINT "UQ_4a9c4fd7b9476e68d5605420bf4" UNIQUE ("referralRewardId")`);
//         await queryRunner.query(`ALTER TABLE "referral_usage" ADD CONSTRAINT "FK_ecb9afc41d116dcbe4383ec5741" FOREIGN KEY ("userId") REFERENCES "users"("id") ON DELETE NO ACTION ON UPDATE NO ACTION`);
//         await queryRunner.query(`ALTER TABLE "referral_usage" ADD CONSTRAINT "FK_84f519522ef178ae52f925c198b" FOREIGN KEY ("referralId") REFERENCES "referral"("id") ON DELETE NO ACTION ON UPDATE NO ACTION`);
//         await queryRunner.query(`ALTER TABLE "referral" ADD CONSTRAINT "FK_1fbffba89b7ed9ca14a5b750240" FOREIGN KEY ("userId") REFERENCES "users"("id") ON DELETE NO ACTION ON UPDATE NO ACTION`);
//         await queryRunner.query(`ALTER TABLE "referral_reward" ADD CONSTRAINT "FK_2ffef22fc829d68eb69e9be8cb6" FOREIGN KEY ("userId") REFERENCES "users"("id") ON DELETE NO ACTION ON UPDATE NO ACTION`);
//         await queryRunner.query(`ALTER TABLE "users" ADD CONSTRAINT "FK_01d209a8373b77bca9e6e2190d0" FOREIGN KEY ("referrerId") REFERENCES "referral"("id") ON DELETE NO ACTION ON UPDATE NO ACTION`);
//         await queryRunner.query(`ALTER TABLE "users" ADD CONSTRAINT "FK_4a9c4fd7b9476e68d5605420bf4" FOREIGN KEY ("referralRewardId") REFERENCES "referral_reward"("id") ON DELETE NO ACTION ON UPDATE NO ACTION`);
//     }

//     public async down(queryRunner: QueryRunner): Promise<void> {
//         await queryRunner.query(`ALTER TABLE "users" DROP CONSTRAINT "FK_4a9c4fd7b9476e68d5605420bf4"`);
//         await queryRunner.query(`ALTER TABLE "users" DROP CONSTRAINT "FK_01d209a8373b77bca9e6e2190d0"`);
//         await queryRunner.query(`ALTER TABLE "referral_reward" DROP CONSTRAINT "FK_2ffef22fc829d68eb69e9be8cb6"`);
//         await queryRunner.query(`ALTER TABLE "referral" DROP CONSTRAINT "FK_1fbffba89b7ed9ca14a5b750240"`);
//         await queryRunner.query(`ALTER TABLE "referral_usage" DROP CONSTRAINT "FK_84f519522ef178ae52f925c198b"`);
//         await queryRunner.query(`ALTER TABLE "referral_usage" DROP CONSTRAINT "FK_ecb9afc41d116dcbe4383ec5741"`);
//         await queryRunner.query(`ALTER TABLE "users" DROP CONSTRAINT "UQ_4a9c4fd7b9476e68d5605420bf4"`);
//         await queryRunner.query(`ALTER TABLE "users" DROP COLUMN "referralRewardId"`);
//         await queryRunner.query(`ALTER TABLE "users" DROP COLUMN "referrerId"`);
//         await queryRunner.query(`DROP TABLE "referral_reward"`);
//         await queryRunner.query(`DROP TABLE "referral"`);
//         await queryRunner.query(`DROP TABLE "referral_usage"`);
//     }

// }
