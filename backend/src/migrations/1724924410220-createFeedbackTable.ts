// import { MigrationInterface, QueryRunner } from 'typeorm';

// export class CreateFeedbackTable1724924410220 implements MigrationInterface {
// 	name = 'CreateFeedbackTable1724924410220';

// 	public async up(queryRunner: QueryRunner): Promise<void> {
// 		await queryRunner.query(
// 			`CREATE TYPE "public"."feedback_type_enum" AS ENUM('FEEDBACK', 'FEATURE_SUGGESTION')`
// 		);
// 		await queryRunner.query(
// 			`CREATE TABLE "feedback" ("id" uuid NOT NULL DEFAULT uuid_generate_v4(), "createdAt" TIMESTAMP NOT NULL DEFAULT now(), "updatedAt" TIMESTAMP NOT NULL DEFAULT now(), "deletedAt" TIMESTAMP, "type" "public"."feedback_type_enum" NOT NULL, "message" character varying NOT NULL, "userId" uuid, CONSTRAINT "PK_8389f9e087a57689cd5be8b2b13" PRIMARY KEY ("id"))`
// 		);
// 		await queryRunner.query(
// 			`ALTER TABLE "feedback" ADD CONSTRAINT "FK_4a39e6ac0cecdf18307a365cf3c" FOREIGN KEY ("userId") REFERENCES "users"("id") ON DELETE NO ACTION ON UPDATE NO ACTION`
// 		);
// 	}

// 	public async down(queryRunner: QueryRunner): Promise<void> {
// 		await queryRunner.query(
// 			`ALTER TABLE "feedback" DROP CONSTRAINT "FK_4a39e6ac0cecdf18307a365cf3c"`
// 		);
// 		await queryRunner.query(`DROP TABLE "feedback"`);
// 		await queryRunner.query(`DROP TYPE "public"."feedback_type_enum"`);
// 	}
// }
