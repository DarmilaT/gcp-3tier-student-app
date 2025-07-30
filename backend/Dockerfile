# Use an official Node.js 22.17 image
FROM node:22.17.0

# Set working directory
WORKDIR /app

# Copy package.json and package-lock.json
COPY package*.json ./

# Install dependencies
RUN npm install

# Copy the rest of the application code
COPY . .

# Expose the backend port
EXPOSE 3500

# Run the application
CMD ["node", "index.js"]