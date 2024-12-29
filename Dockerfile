FROM node:20-alpine as build-stage
WORKDIR /app
COPY package*.json ./
RUN npm install
COPY . .

# Set at build time because it is needed to determine if the app is static or dynamic
ARG VITE_APPLICATIONINSIGHTS_CONNECTION_STRING
ENV VITE_APPLICATIONINSIGHTS_CONNECTION_STRING=$VITE_APPLICATIONINSIGHTS_CONNECTION_STRING



RUN npm run build

FROM nginx:stable-alpine as production-stage
COPY --from=build-stage /app/dist /usr/share/nginx/html
COPY nginx.conf.template /etc/nginx/templates/default.conf.template
COPY docker-entrypoint.sh /docker-entrypoint.sh
RUN chmod +x /docker-entrypoint.sh

 # Defined at build time
 ARG VITE_IS_STATIC=false
 # Make the VITE_IS_STATIC availavle at runtime using -e VITE_IS_STATIC=xxx
 ENV VITE_IS_STATIC=$VITE_IS_STATIC
 
 # Set using NGINX reverse proxy so it can be done at runtime, default to localhost (Docker)
 ENV VITE_APP_API_URL="http://host.docker.internal:8080"
 
EXPOSE 80
ENTRYPOINT ["/docker-entrypoint.sh"]
CMD ["nginx", "-g", "daemon off;"]