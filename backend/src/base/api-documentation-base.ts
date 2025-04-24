import { INestApplication } from '@nestjs/common';
import {
	ApiBadRequestResponse,
	ApiNotFoundResponse,
	ApiUnauthorizedResponse,
	DocumentBuilder,
	SwaggerModule
} from '@nestjs/swagger';
import { description, name, tag, version } from '../../package.json';

@ApiNotFoundResponse({
	description: 'Not Found'
})
@ApiBadRequestResponse({
	description: 'Bad Request'
})
@ApiUnauthorizedResponse({
	description: 'Unauthorized'
})

// We use Swagger for api documentation- The Swagger framework allows developers to create interactive, machine and human-readable API documentation.
export class ApiDocumentationBase {
	static initApiDocumentation(app: INestApplication<any>): void {
		const config = new DocumentBuilder()
			.setTitle(name)
			.setDescription(description)
			.setVersion(version)
			.addBearerAuth()
			.addTag(tag)
			.build();
		const document = SwaggerModule.createDocument(app, config);
		SwaggerModule.setup('api', app, document);

		const adminConfig = new DocumentBuilder()
			.setTitle('Public API Docs')
			.setDescription('Contains only public-related APIs')
			.setVersion('1.0')
			.addBearerAuth()
			.build();

		const adminDocument = SwaggerModule.createDocument(app, adminConfig);

		Object.keys(adminDocument.paths).forEach(path => {
			if (!path.includes('/public')) {
				delete adminDocument.paths[path]; // Remove paths that do NOT contain 'public'
			}
		});

		SwaggerModule.setup('public-api', app, adminDocument);
	}
}
