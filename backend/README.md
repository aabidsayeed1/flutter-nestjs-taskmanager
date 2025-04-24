<p align="center">
  <a href="http://nestjs.com/" target="blank"><img src="https://nestjs.com/img/logo-small.svg" width="200" alt="Nest Logo" /></a>
</p>

[circleci-image]: https://img.shields.io/circleci/build/github/nestjs/nest/master?token=abc123def456
[circleci-url]: https://circleci.com/gh/nestjs/nest

  <p align="center">A progressive <a href="http://nodejs.org" target="_blank">Node.js</a> framework for building efficient and scalable server-side applications.</p>
    <p align="center">
<a href="https://www.npmjs.com/~nestjscore" target="_blank"><img src="https://img.shields.io/npm/v/@nestjs/core.svg" alt="NPM Version" /></a>
<a href="https://www.npmjs.com/~nestjscore" target="_blank"><img src="https://img.shields.io/npm/l/@nestjs/core.svg" alt="Package License" /></a>
<a href="https://www.npmjs.com/~nestjscore" target="_blank"><img src="https://img.shields.io/npm/dm/@nestjs/common.svg" alt="NPM Downloads" /></a>
<a href="https://circleci.com/gh/nestjs/nest" target="_blank"><img src="https://img.shields.io/circleci/build/github/nestjs/nest/master" alt="CircleCI" /></a>
<a href="https://coveralls.io/github/nestjs/nest?branch=master" target="_blank"><img src="https://coveralls.io/repos/github/nestjs/nest/badge.svg?branch=master#9" alt="Coverage" /></a>
<a href="https://discord.gg/G7Qnnhy" target="_blank"><img src="https://img.shields.io/badge/discord-online-brightgreen.svg" alt="Discord"/></a>
<a href="https://opencollective.com/nest#backer" target="_blank"><img src="https://opencollective.com/nest/backers/badge.svg" alt="Backers on Open Collective" /></a>
<a href="https://opencollective.com/nest#sponsor" target="_blank"><img src="https://opencollective.com/nest/sponsors/badge.svg" alt="Sponsors on Open Collective" /></a>
  <a href="https://paypal.me/kamilmysliwiec" target="_blank"><img src="https://img.shields.io/badge/Donate-PayPal-ff3f59.svg"/></a>
    <a href="https://opencollective.com/nest#sponsor"  target="_blank"><img src="https://img.shields.io/badge/Support%20us-Open%20Collective-41B883.svg" alt="Support us"></a>
  <a href="https://twitter.com/nestframework" target="_blank"><img src="https://img.shields.io/twitter/follow/nestframework.svg?style=social&label=Follow"></a>
</p>
  <!--[![Backers on Open Collective](https://opencollective.com/nest/backers/badge.svg)](https://opencollective.com/nest#backer)
  [![Sponsors on Open Collective](https://opencollective.com/nest/sponsors/badge.svg)](https://opencollective.com/nest#sponsor)-->

## Description

[Nest](https://github.com/nestjs/nest) framework TypeScript starter repository.

## Installation

```bash
$ npm install
```

## Running the app

```bash
# development
$ npm run start

# watch mode
$ npm run start:dev

# production mode
$ npm run start:prod
```

## Test

```bash
# unit tests
$ npm run test

# e2e tests
$ npm run test:e2e

# test coverage
$ npm run test:cov
```

## Support

Nest is an MIT-licensed open source project. It can grow thanks to the sponsors and support by the amazing backers. If you'd like to join them, please [read more here](https://docs.nestjs.com/support).

## Stay in touch

- Author - [Kamil Myśliwiec](https://kamilmysliwiec.com)
- Website - [https://nestjs.com](https://nestjs.com/)
- Twitter - [@nestframework](https://twitter.com/nestframework)

## License

Nest is [MIT licensed](LICENSE).

## App Version Update Handling

This section outlines how the system handles version updates based on the user's current version.

### Update Scenarios

| SCENARIO | USER VERSION | ACTION TRIGGERED | NOTIFY UPDATE | FORCE UPDATE | LATEST VERSION | FEATURES |
|----------|-------------|------------------|---------------|--------------|----------------|----------|
| User on version 1.9.0 triggers a forced update to 2.3.0 with features [events, home] | 1.9.0 | Forced Update | TRUE | TRUE | 2.3.0 | [events, home] |
| User on version 2.0.0 triggers an optional update to 2.3.0 with features [events, home] | 2.0.0 | Optional Update | TRUE | FALSE | 2.3.0 | [events, home] |
| User on version 2.1.0 triggers an optional update to 2.3.0 with features [events, home] | 2.1.0 | Optional Update | TRUE | FALSE | 2.3.0 | [events, home] |
| User on version 2.2.0 triggers an optional update to 2.3.0 with feature [home] | 2.2.0 | Optional Update | TRUE | FALSE | 2.3.0 | [home] |
| User on version 2.3.0 requires no action | 2.3.0 | No Action | FALSE | FALSE | 2.3.0 | [] |

### Server Configuration

| Min Version | Latest Version | Features |
|------------|---------------|----------|
| 2.0.0 | 2.3.0 | `{"events":{"minVersion":"2.2.0"},"home":{"minVersion":"2.3.0"}}` |

### API Details

#### Request Format:
```json
{
  "versionName": "string",
  "buildNumber": "string",
  "os": "android" | "ios",
  "osVersion": "string"
}
```

#### Response Format:
```json
{
  "notifyUpdate": true,
  "forceUpdate": true,
  "latestVersion": "2.3.0",
  "features": []
}
```

## Summary of Outputs

This section outlines possible responses based on the user's current app version.

| CASE | INPUT | OUTPUT |
|------|-------|--------|
| No Update Required | 2.3.0 | ```json {"notifyUpdate": false, "latestVersion": "2.3.0", "forceUpdate": false, "features": []}``` |
| Forced Update (Below Minimum Version) | 1.9.0 | ```json {"notifyUpdate": true, "latestVersion": "2.3.0", "forceUpdate": true, "features": ["events", "home"]}``` |
| Optional Update with events and home | 2.0.0 | ```json {"notifyUpdate": true, "latestVersion": "2.3.0", "forceUpdate": false, "features": ["events", "home"]}``` |
| Optional Update with events and home | 2.1.0 | ```json {"notifyUpdate": true, "latestVersion": "2.3.0", "forceUpdate": false, "features": ["events", "home"]}``` |
| Optional Update with home | 2.2.0 | ```json {"notifyUpdate": true, "latestVersion": "2.3.0", "forceUpdate": false, "features": ["home"]}``` |

## Environment Variables

These environment variables control versioning logic for both Android and iOS.

```env
# Minimum and latest Android versions
APP_VERSIONS_MIN_ANDROID_VERSION_NAME=2.0.0
APP_VERSIONS_LATEST_VERSION_OF_ANDROID=2.3.0

# Minimum and latest iOS versions
APP_VERSIONS_MIN_IOS_VERSION_NAME=2.0.0
APP_VERSIONS_LATEST_VERSION_OF_IOS=2.3.0

# Feature-specific minimum version requirements
APP_VERSIONS_FEATURES={"events":{"minVersion":"2.2.0"},"home":{"minVersion":"2.3.0"}}
```
