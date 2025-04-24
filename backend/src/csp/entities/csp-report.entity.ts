import {
	Entity,
	PrimaryGeneratedColumn,
	Column,
	CreateDateColumn
} from 'typeorm';

@Entity()
export class CspReport {
	@PrimaryGeneratedColumn()
	id!: number;

	@Column()
	documentUri!: string;

	@Column()
	referrer!: string;

	@Column()
	blockedUri!: string;

	@Column()
	violatedDirective!: string;

	@Column()
	originalPolicy!: string;

	@CreateDateColumn()
	createdAt!: Date;
}
