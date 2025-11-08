FROM nginx:alpine

# Create directory and set permissions
RUN mkdir -p /usr/share/nginx/html/images

# Copy website files to nginx html directory
COPY index.html /usr/share/nginx/html/
COPY images/ /usr/share/nginx/html/images/

# Set proper permissions
RUN chmod -R 755 /usr/share/nginx/html/images/

# Expose port 80
EXPOSE 80

# Start nginx
CMD ["nginx", "-g", "daemon off;"]
