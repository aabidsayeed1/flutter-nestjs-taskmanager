# Use Node.js 20 LTS (Long Term Support) version
FROM node:20-alpine
# Create app directory
WORKDIR /usr/app

# Copy app files
COPY . .