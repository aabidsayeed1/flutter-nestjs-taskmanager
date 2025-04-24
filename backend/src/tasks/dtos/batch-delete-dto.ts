import { IsArray, IsUUID } from 'class-validator';

export class BatchDeleteDto {
  @IsArray()
  @IsUUID('4', { each: true })
  taskIds!: string[];
}