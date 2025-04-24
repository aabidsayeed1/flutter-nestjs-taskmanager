// import { QueryRunner } from 'typeorm';
// import { InitialSetup1724844121328 } from './migrations/1724844121328-initialSetup';

// describe('User Migration', () => {
// 	let migration: InitialSetup1724844121328;
// 	let queryRunner: QueryRunner;

// 	beforeEach(() => {
// 		migration = new InitialSetup1724844121328();
// 		queryRunner = {
// 			query: jest.fn()
// 		} as unknown as QueryRunner;
// 	});

// 	it('should have a name property', () => {
// 		expect(migration.name).toBe('InitialSetup1724844121328');
// 	});

// 	describe('up', () => {
// 		it('should create the users table', async () => {
// 			await migration.up(queryRunner);
// 			expect(queryRunner.query).toHaveBeenCalledWith(
// 				`CREATE TABLE "users" ("id" uuid NOT NULL DEFAULT uuid_generate_v4(), "createdAt" TIMESTAMP NOT NULL DEFAULT now(), "updatedAt" TIMESTAMP NOT NULL DEFAULT now(), "deletedAt" TIMESTAMP, "name" character varying, "email" character varying NOT NULL, "password" character varying NOT NULL, "isVerified" boolean NOT NULL DEFAULT false, "verificationToken" character varying, "resetPasswordToken" character varying, "resetPasswordExpires" TIMESTAMP, CONSTRAINT "UQ_97672ac88f789774dd47f7c8be3" UNIQUE ("email"), CONSTRAINT "PK_a3ffb1c0c8416b9fc6f907b7433" PRIMARY KEY ("id"))`
// 			);
// 		});
// 	});

// 	describe('down', () => {
// 		it('should drop the users table', async () => {
// 			await migration.down(queryRunner);
// 			expect(queryRunner.query).toHaveBeenCalledWith(
// 				`DROP TABLE "users"`
// 			);
// 		});
// 	});
// });
