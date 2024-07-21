FROM node:18

WORKDIR /app
COPY . .
RUN ls
RUN npm install
RUN npm install prom-client
# COPY . .

# install nginx
RUN apt-get update && apt-get install -y nginx 

# replace the default nginx configuration with ours
COPY nginx.conf /etc/nginx/nginx.conf

# Expose both port 80 (for the website)
EXPOSE 80
CMD ["/usr/sbin/nginx", "-g", "daemon off;"]