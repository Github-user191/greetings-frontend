#!/bin/sh

# Define the API location block
api_location_block=$(cat <<EOF
    location /api/ {
        proxy_pass ${VITE_APP_API_URL};
        proxy_set_header Host \$host;
        proxy_set_header X-Real-IP \$remote_addr;
        proxy_set_header X-Forwarded-For \$proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto \$scheme;
        error_page 502 503 504 = /index.html;
    }
EOF
)

echo "VITE_IS_STATIC: $VITE_IS_STATIC"
echo "VITE_APP_API_URL: $VITE_APP_API_URL"

# Generate API location block or leave it empty based on VITE_IS_STATIC
if [ "$VITE_IS_STATIC" = "true" ]; then
    api_location_block=""
fi

echo "API_LOCATION_BLOCK: $api_location_block"
# Replace environment variables in the template
envsubst '${VITE_APP_API_URL}' < /etc/nginx/templates/default.conf.template > /etc/nginx/conf.d/default.conf

# Inject the API location block into the configuration
if [ -n "$api_location_block" ]; then
    awk -v block="$api_location_block" '/# Handle \/api/ {print; print block; next}1' /etc/nginx/conf.d/default.conf > /tmp/default.conf
    mv /tmp/default.conf /etc/nginx/conf.d/default.conf
fi

# Start Nginx
exec "$@"
