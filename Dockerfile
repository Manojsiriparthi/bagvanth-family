# Use nginx alpine image for smaller size
FROM nginx:alpine

# Copy application files to nginx html directory
COPY . /usr/share/nginx/html/

# Remove the default nginx welcome page if it exists
RUN rm -f /usr/share/nginx/html/index.html

# Create a basic index.html if none exists
RUN if [ ! -f /usr/share/nginx/html/index.html ]; then \
    echo '<!DOCTYPE html>' > /usr/share/nginx/html/index.html && \
    echo '<html lang="en">' >> /usr/share/nginx/html/index.html && \
    echo '<head>' >> /usr/share/nginx/html/index.html && \
    echo '    <meta charset="UTF-8">' >> /usr/share/nginx/html/index.html && \
    echo '    <meta name="viewport" content="width=device-width, initial-scale=1.0">' >> /usr/share/nginx/html/index.html && \
    echo '    <title>Bagvanth Family Connect</title>' >> /usr/share/nginx/html/index.html && \
    echo '    <style>body{font-family:Arial,sans-serif;margin:40px;background:#f5f5f5}#app{max-width:800px;margin:0 auto;background:white;padding:20px;border-radius:8px;box-shadow:0 2px 10px rgba(0,0,0,0.1)}</style>' >> /usr/share/nginx/html/index.html && \
    echo '</head>' >> /usr/share/nginx/html/index.html && \
    echo '<body>' >> /usr/share/nginx/html/index.html && \
    echo '    <div id="app">' >> /usr/share/nginx/html/index.html && \
    echo '        <h1>Bagvanth Family Connect</h1>' >> /usr/share/nginx/html/index.html && \
    echo '        <div id="family-members"></div>' >> /usr/share/nginx/html/index.html && \
    echo '    </div>' >> /usr/share/nginx/html/index.html && \
    echo '    <script src="js/connect.js"></script>' >> /usr/share/nginx/html/index.html && \
    echo '</body>' >> /usr/share/nginx/html/index.html && \
    echo '</html>' >> /usr/share/nginx/html/index.html; \
    fi

# Expose port 80
EXPOSE 80

# Start nginx
CMD ["nginx", "-g", "daemon off;"]
