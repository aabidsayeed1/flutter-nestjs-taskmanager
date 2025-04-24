module.exports = {
	moduleFileExtensions: ['js', 'json', 'ts'],
	rootDir: 'src',
	testRegex: '.*\\.spec\\.ts$',
	transform: {
		'^.+\\.(t|j)s$': 'ts-jest'
	},
	collectCoverageFrom: ['**/*.(t|j)s'],
	coverageDirectory: '../coverage',
	preset: 'ts-jest',
	testEnvironment: 'node',
	coveragePathIgnorePatterns: [
		'/dto/.*\\.dto\\.ts$',
		'.strategy',
		'.config',
		'email.service',
		'/src/config/.*\\.ts$',
		'main.ts',
		'app.module.ts',
		'.guard.ts'
	],
	moduleNameMapper: {
		'^@/(.*)$': '<rootDir>/$1'
	},
	setupFilesAfterEnv: ['./config/test-setup.ts']
};
