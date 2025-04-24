import { Response } from '@/utils/response/decorators/response.decorator';
import {
	Body,
	Controller,
	Delete,
	Get,
	Param,
	Patch,
	Req
} from '@nestjs/common';
import { Request } from 'express';
import { FindUserDto } from './dto/find-user.dto';
import { UpdateUserDto } from './dto/update-user.dto';
import { UserService } from './user.service';
@Controller('users')
export class UserController {
	constructor(private userService: UserService) {}

	@Get('profile')
	getProfile(@Req() req: Request) {
		return req.user;
	}

	@Response('success', FindUserDto)
	@Get(':id')
	async getUserById(@Param('id') id: string) {
		const user = await this.userService.findOne(id);
		return user;
	}

	@Patch('profile/:id')
	async updateProfile(@Param('id') id: string, @Body() body: UpdateUserDto) {
		return this.userService.update(id, body);
	}

	@Response('success')
	@Delete(':id')
	async deleteUser(@Param('id') id: string) {
		await this.userService.remove(id);
	}
}
