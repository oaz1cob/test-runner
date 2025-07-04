# Stage 1: Build the React application
FROM node:20-bookworm AS builder

WORKDIR /app

# Copy package files first for better layer caching
COPY package*.json ./
RUN npm install --frozen-lockfile  # Ensures exact versions are installed

# Copy the rest of the source code
COPY . .

# Build the React app (works for Vite, CRA, etc.)
RUN npm run build

# Stage 2: Serve the app using Node (Bookworm-based)
FROM node:20-bookworm-slim

WORKDIR /app

# Install a lightweight HTTP server (if not using Nginx)
RUN npm install -g serve

# Copy built assets from the builder stage
COPY --from=builder /app/dist ./dist

# Expose port (default for `serve` is 3000, but can be changed)
EXPOSE 3000

# Start the HTTP server
CMD ["serve", "-s", "dist", "-l", "3000"]
