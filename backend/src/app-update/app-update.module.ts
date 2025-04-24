import { Module } from '@nestjs/common';
import { AppUpdateController } from './app-update.controller';
import { AppUpdateService } from './app-update.service';


@Module({
  controllers: [AppUpdateController], 
  providers: [AppUpdateService], 
})
export  class AppUpdateModule {} {}