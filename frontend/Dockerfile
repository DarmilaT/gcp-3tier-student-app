# -------- Stage 1: Build the frontend app --------
FROM node:22-alpine as build
WORKDIR /app

# Copy all files to the container
COPY . .

# Install dependencies
RUN npm install

# Build the production-ready static files
RUN npm run build

# -------- Stage 2: Serve the build with Nginx --------
FROM nginx:1.25.3-alpine

# Copy build output to Nginx’s default web directory
COPY --from=build /app/build /usr/share/nginx/html

# Expose port 80
EXPOSE 80

# Start Nginx in the foreground
CMD ["nginx", "-g", "daemon off;"]
