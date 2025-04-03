FROM nginx:alpine

WORKDIR /usr/share/nginx/html

# Copy our custom nginx configuration
COPY nginx.conf /etc/nginx/conf.d/default.conf

# Copy our website files
COPY . .

EXPOSE 80

CMD ["nginx", "-g", "daemon off;"]