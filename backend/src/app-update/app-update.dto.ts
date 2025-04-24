import { ApiProperty } from '@nestjs/swagger';
import { IsString, IsNotEmpty, IsEnum } from 'class-validator';

export enum SupportedOS {
  Android = 'android',
  iOS = 'ios',
}

export class AppUpdateDto {
  @ApiProperty({
    description: 'The full version name of the app (e.g., X.Y.Z)',
    example: '1.2.3',
  })
  @IsString()
  @IsNotEmpty()
  versionName!: string;

  @ApiProperty({
    description: 'The operating system of the device (e.g., ios or android)',
    example: 'ios',
    enum: SupportedOS,
  })
  @IsEnum(SupportedOS, {
    message: 'os must be one of the following values: android, ios',
  })
  os!: SupportedOS;

  @ApiProperty({
    description: 'The build number of the app',
    example: '12345',
  })
  @IsString()
  @IsNotEmpty()
  buildNumber!: string;

  @ApiProperty({
    description: 'The version of the operating system (e.g., 14.4.1)',
    example: '14.4.1',
  })
  @IsString()
  @IsNotEmpty()
  osVersion!: string;
}