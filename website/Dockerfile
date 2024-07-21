FROM node:18

WORKDIR /app
COPY package*.json ./
RUN npm install
COPY . .

# install nginx
RUN apt-get update && apt-get install -y nginx

# replace the default nginx configuration with ours
COPY nginx.conf /etc/nginx/nginx.conf

# expose port 80 and define the command to run when starting the container
EXPOSE 80
CMD ["/usr/sbin/nginx", "-g", "daemon off;"]