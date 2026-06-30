FROM node:20-alpine

WORKDIR /app

# Install dependencies
COPY package.json ./
RUN npm install --production

# Copy source
COPY src/ ./src/

EXPOSE 8080

CMD ["node", "src/relay.js"]
