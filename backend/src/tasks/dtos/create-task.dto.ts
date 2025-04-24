import { ApiProperty } from '@nestjs/swagger';
import { Transform, TransformFnParams } from 'class-transformer';
import { IsString, IsNotEmpty, IsDate, IsBoolean, IsOptional, IsUUID } from 'class-validator';

export class CreateTaskDto {
  @ApiProperty({ example: 'uuid' })
  @IsUUID('4')
  @IsNotEmpty()
  id!: string; 
  @ApiProperty({ example: 'Complete NestJS API' })
  @IsString()
  @IsNotEmpty()
  title!: string;

  @ApiProperty({ example: 'Finish implementing the Task Manager API' })
  @IsString()
  @IsNotEmpty()
  description!: string;

  @ApiProperty({ example: '2023-10-15' })
  @IsString()
  @IsNotEmpty()
  date!: string;

  @ApiProperty({ example: false, required: false, default: false })
  @IsBoolean()
  @IsOptional()
  isDone?: boolean;

  @ApiProperty({ example: false, required: false, default: false })
  @IsBoolean()
  @IsOptional()
  isDeleted?: boolean;

  @ApiProperty({ example: false, required: false, default: false })
  @IsBoolean()
  @IsOptional()
  isFavorite?: boolean;
  
  @ApiProperty({ example: false, required: false , default: false})
  @IsBoolean()
  @IsOptional()
  isOffline?: boolean;
}