# Use a lightweight, production-grade Nginx image
FROM nginx:alpine

# Copy your static website into Nginx's default web directory
COPY site/ /usr/share/nginx/html/

# Expose port 80 (documentation for users/tools)
EXPOSE 80

