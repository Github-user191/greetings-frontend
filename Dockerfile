FROM node:20-alpine as build-stage
WORKDIR /app
COPY package*.json ./
RUN npm install
COPY . .

ARG VITE_IS_STATIC
ENV VITE_IS_STATIC=$VITE_IS_STATIC

ARG VITE_APPLICATIONINSIGHTS_CONNECTION_STRING
ENV VITE_APPLICATIONINSIGHTS_CONNECTION_STRING=$VITE_APPLICATIONINSIGHTS_CONNECTION_STRING

RUN echo "CONNECTION STRING is set to: $VITE_APPLICATIONINSIGHTS_CONNECTION_STRING"
RUN npm run build
FROM nginx:stable-alpine as production-stage
COPY --from=build-stage /app/dist /usr/share/nginx/html

COPY nginx.conf /etc/nginx/conf.d/default.conf

EXPOSE 80
CMD ["nginx", "-g", "daemon off;"] 