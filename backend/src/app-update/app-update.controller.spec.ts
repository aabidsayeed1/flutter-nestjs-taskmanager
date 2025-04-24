import { Test, TestingModule } from '@nestjs/testing';
import { INestApplication } from '@nestjs/common';
import request from 'supertest';
import { ValidationPipe } from '@nestjs/common';
import { AppUpdateController } from './app-update.controller';
import { AppUpdateService } from './app-update.service';
import { AppUpdateDto, SupportedOS } from './app-update.dto';

describe('AppUpdateController', () => {
  let app: INestApplication;
  let appUpdateService: AppUpdateService;

  beforeAll(async () => {
    const moduleFixture: TestingModule = await Test.createTestingModule({
      controllers: [AppUpdateController],
      providers: [
        {
          provide: AppUpdateService,
          useValue: {
            verifyVersion: jest.fn(), // Mock the service method
          },
        },
      ],
    }).compile();

    app = moduleFixture.createNestApplication();
    app.useGlobalPipes(new ValidationPipe()); // Enable global validation
    await app.init();

    appUpdateService = moduleFixture.get<AppUpdateService>(AppUpdateService);
  });

  afterAll(async () => {
    await app.close();
  });

  describe('POST /app-update', () => {
    it('should return a valid response for valid input', async () => {
      const mockResponse = {
        notifyUpdate: true,
        latestVersion: '2.3.0',
        forceUpdate: false,
        features: ['profile', 'videoContent'],
      };
      const validDto: AppUpdateDto = {
        versionName: '2.0.0',
        os: SupportedOS.Android,
        buildNumber: '12345',
        osVersion: '11.0',
      };

      jest.spyOn(appUpdateService, 'verifyVersion').mockResolvedValue(mockResponse as never);
      const response = await request(app.getHttpServer())
        .post('/app-update')
        .send(validDto)
        .expect(201); 

      expect(response.body).toEqual(mockResponse);
      expect(appUpdateService.verifyVersion).toHaveBeenCalledWith(validDto);
    });

    it('should return 400 for invalid input (missing required fields)', async () => {
      const invalidDto = {
        versionName: '', 
        os: 'android',
        buildNumber: '12345',
        osVersion: '11.0',
      };

      const response = await request(app.getHttpServer())
        .post('/app-update')
        .send(invalidDto)
        .expect(400);

      expect(response.body.message).toContain('versionName should not be empty');
    });    
  });
});