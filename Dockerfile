# Stage 1: Build
FROM node:18 AS builder

# Set working directory
WORKDIR /app

# Copy only package.json files and install deps
COPY package*.json ./
RUN npm install

# Copy rest of the code and build
COPY . .
RUN npm run build

# Stage 2: Production image
FROM node:18-slim

# Set working directory
WORKDIR /app

# Copy only the dist/ folder and node_modules from builder stage
COPY --from=builder /app/dist ./dist
COPY --from=builder /app/node_modules ./node_modules
COPY package*.json ./

# Expose the backend port (update if you use a different one)
EXPOSE 4000

# Start the app
CMD ["node", "dist/server.js"]
