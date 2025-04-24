import { Column, Entity, PrimaryGeneratedColumn } from 'typeorm';

@Entity()
export class Task {
  @PrimaryGeneratedColumn('uuid')
  id!: string;

  @Column({ type: 'varchar', nullable: false })
  title!: string;

  @Column({ type: 'text', nullable: false })
  description!: string;

  @Column({ type: 'date', nullable: false })
  date!: Date;

  @Column({ type: 'boolean', default: false })
  isDone!: boolean;

  @Column({ type: 'boolean', default: false })
  isDeleted!: boolean;

  @Column({ type: 'boolean', default: false })
  isFavorite!: boolean;
  
  @Column({ type: 'boolean', default: false })
  isOffline!: boolean;

  @Column({ type: 'varchar', nullable: true })
  userId!: string;
}