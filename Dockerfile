# Build stage
FROM node:lts-alpine AS build-stage
WORKDIR /app

# Install dependencies
COPY package*.json ./
RUN npm install

# Copy source code
COPY . .

# Build-time arguments
ARG VITE_IS_STATIC=false
ARG VITE_APP_API_URL="http://host.docker.internal:8080"
ARG VITE_APPLICATIONINSIGHTS_CONNECTION_STRING

# Make build arguments available as environment variables during build
ENV VITE_IS_STATIC=${VITE_IS_STATIC}
ENV VITE_APP_API_URL=${VITE_APP_API_URL}
ENV VITE_APPLICATIONINSIGHTS_CONNECTION_STRING=${VITE_APPLICATIONINSIGHTS_CONNECTION_STRING}

# Build the application
RUN npm run build

# Production stage
FROM nginx:stable-alpine AS production-stage

# Copy built assets
COPY --from=build-stage /app/dist /usr/share/nginx/html

# Copy nginx configuration template and entrypoint script
COPY nginx.conf.template /etc/nginx/templates/default.conf.template

# Entrypoint script runs when the container starts, we replace the PROXY_CONFIG placeholder with the valid location block for the API
COPY docker-entrypoint.sh /docker-entrypoint.sh 
RUN chmod +x /docker-entrypoint.sh

# Runtime environment variables with defaults
ENV VITE_IS_STATIC=${VITE_IS_STATIC:-false}
ENV VITE_APP_API_URL=${VITE_APP_API_URL:-http://host.docker.internal:8080}

EXPOSE 80

ENTRYPOINT ["/docker-entrypoint.sh"]
CMD ["nginx", "-g", "daemon off;"]

# Usage for Static Mode:
# Build
# docker build --build-arg VITE_IS_STATIC=true -t vue-app:static .
# Run
# docker run -d -p 80:80 -e VITE_IS_STATIC=true vue-app:static

# Usage for Dynamic Mode:
# Build
# docker build --build-arg VITE_APP_API_URL=http://your-api-server:8080 -t vue-app:1.0.0 .
# Run
# docker run -d -p 80:80 -e VITE_APP_API_URL=http://your-api-server:8080 vue-app:1.0.0