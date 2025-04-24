import { Module } from '@nestjs/common';
import { TypeOrmModule } from '@nestjs/typeorm';
import { CspController } from './csp.controller';
import { CspService } from './csp.service';
import { CspReport } from './entities/csp-report.entity';
@Module({
	imports: [TypeOrmModule.forFeature([CspReport])],
	controllers: [CspController],
	providers: [CspService]
})
export class CspModule {}
