import {
	Body,
	Controller,
	Post,
	UsePipes,
	ValidationPipe,
  } from '@nestjs/common';
  import { ApiTags, ApiOkResponse, ApiBadRequestResponse } from '@nestjs/swagger';
  import { AppUpdateDto } from './app-update.dto';
  import { AppUpdateService } from './app-update.service';
  
  @ApiTags('App Update')
  @Controller('app-update')
  export class AppUpdateController {
	constructor(private readonly appUpdateService: AppUpdateService) {}
  
	@Post()
	@UsePipes(new ValidationPipe())
	@ApiOkResponse({
	  description: 'Successfully got app version!',
	})
	@ApiBadRequestResponse({
	  description: 'Failed to get app version!',
	})
	async isAppUpdateAvailable(@Body() appUpdateDto: AppUpdateDto) {
	  return this.appUpdateService.verifyVersion(appUpdateDto);
	}
  }