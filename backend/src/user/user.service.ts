import { I18nHelperService } from '@/i18n-helper/i18n-helper.service';
import { Injectable, NotFoundException } from '@nestjs/common';
import { InjectRepository } from '@nestjs/typeorm';
import * as bcrypt from 'bcrypt';
import { Repository } from 'typeorm';
import { CreateUserDto } from './dto/create-user.dto';
import { UpdateUserDto } from './dto/update-user.dto';
import { User } from './entities/user.entity';
import { CreateUserByPhoneDto } from './dto/create-user-by-phone.dto';
// import { UpdateUserDto } from './dto/update-user.dto';

@Injectable()
export class UserService {
	constructor(
		@InjectRepository(User)
		private userRepository: Repository<User>,
		private i18nHelperService: I18nHelperService
	) {}

	async create(createUserDto: CreateUserDto): Promise<User> {
		const user = this.userRepository.create(createUserDto);
		return await this.userRepository.save(user);
	}


	async update(id: string, updateUserDto: UpdateUserDto): Promise<User> {
		const user = await this.userRepository.findOne({ where: { id } });
		if (!user) {
			throw new NotFoundException(
				this.i18nHelperService.t('errors.USER_NOT_FOUND', { id })
			);
		}
		Object.assign(user, updateUserDto);
		return this.userRepository.save(user);
	}

	async findAll(): Promise<User[]> {
		return await this.userRepository.find();
	}

	async findOne(id: string, relations?: any): Promise<User> {
		const user = await this.userRepository.findOne({
			where: { id, deletedAt: undefined },
			relations: relations
		});
		if (!user) {
			throw new NotFoundException(`User with ID ${id} not found`);
		}
		return user;
	}

	async findByEmail(email: string): Promise<User | null> {
		return await this.userRepository.findOne({ where: { email } });
	}

	async findByVerificationToken(token: string): Promise<User | null> {
		return await this.userRepository.findOne({
			where: { verificationToken: token }
		});
	}

	async findByResetPasswordToken(token: string): Promise<User | null> {
		return await this.userRepository.findOne({
			where: { resetPasswordToken: token }
		});
	}

	async save(user: User): Promise<User> {
		return await this.userRepository.save(user);
	}
	async remove(id: string): Promise<void> {
		const user = await this.findOne(id);
		user.deletedAt = new Date();
		await this.save(user);
	}

	async updateRefreshToken(
		userId: string,
		refreshToken: string
	): Promise<void> {
		const user = await this.findOne(userId);
		const saltRounds = 10;
		const hashedRefreshToken = await bcrypt.hash(refreshToken, saltRounds);
		user.refreshToken = hashedRefreshToken;
		await this.save(user);
	}

	async clearRefreshToken(userId: string) {
		const user = await this.findOne(userId);
		user.refreshToken = null;
		await this.save(user);
	}
	async updateUserLanguage(userId: string, language: string) {
		const user = await this.userRepository.findOne({
			where: { id: userId }
		});
		if (!user) {
			throw new Error('User not found');
		}
		user.language = language;
		await this.userRepository.save(user);

		return {
			success: true,
			message: this.i18nHelperService.t(
				'messages.language_update_successful'
			)
		};
	}
	async findByPhoneNumber(phoneNumber: string): Promise<User | null> {
		return this.userRepository.findOne({ where: { phoneNumber } });
	}
	async createUserByPhone(createUserDto: CreateUserByPhoneDto): Promise<User> {
		const user = this.userRepository.create(createUserDto);
		return await this.userRepository.save(user);
	}
}
