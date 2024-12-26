#!/bin/sh

# Define the proxy configuration
if [ "${ENABLE_BACKEND_PROXY}" = "true" ]; then
    proxy_config="location /api/ {
        proxy_pass http://greetings-backend:8080;
        proxy_set_header Host \$host;
        proxy_set_header X-Real-IP \$remote_addr;
        proxy_set_header X-Forwarded-For \$proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto \$scheme;
    }"
else
    proxy_config=""
fi

# Replace the placeholder in the template
export PROXY_CONFIG="$proxy_config"
envsubst '${PROXY_CONFIG}' < /etc/nginx/templates/nginx.conf.template > /etc/nginx/conf.d/default.conf

# Start nginx
exec nginx -g 'daemon off;'