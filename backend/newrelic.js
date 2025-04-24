'use strict'

require('dotenv').config({ path: `.env` });


exports.config = {
  app_name: 'your_app_name_here',
  license_key: process.env.NEW_RELIC_LICENSE_KEY,
  allow_all_headers: true,
  attributes: {
    exclude: [
      'request.headers.cookie',
      'request.headers.authorization',
      'request.headers.proxyAuthorization',
      'request.headers.setCookie*',
      'request.headers.x*',
      'response.headers.cookie',
      'response.headers.authorization',
      'response.headers.proxyAuthorization',
      'response.headers.setCookie*',
      'response.headers.x*'
    ]
  },
  logging: {
    level: 'info',
    enabled: true
  },
  transaction_tracer: {
    enabled: true,
    record_sql: 'obfuscated',
    explain_threshold: 500
  },
  slow_sql: {
    enabled: true,
    max_samples: 5
  }
}