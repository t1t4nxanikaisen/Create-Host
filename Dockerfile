# Use an official Node.js runtime as a base example
FROM node:18-alpine

# Create app directory
WORKDIR /app

# Copy package.json and install dependencies
COPY package*.json ./
RUN npm install --production

# Copy app source
COPY . .

# Build app if needed (optional)
# RUN npm run build

# Expose the port Render assigns via environment variable
ENV PORT=10000
EXPOSE 10000

# Start the app (make sure it listens on process.env.PORT)
CMD ["node", "index.js"]
