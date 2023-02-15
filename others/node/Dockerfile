# FROM node:alpine

# WORKDIR /usr/src/app

# COPY package*.json ./

# RUN npm install --registry=https://registry.npm.taobao.org

# COPY . .

# EXPOSE 8080
# CMD [ "npm", "start" ]
FROM node:12

RUN npm install -g cnpm gulp bower && npm cache clear

WORKDIR /opt
EXPOSE 8001
VOLUME ["/opt"]

CMD node /opt/htdocs/broadcast/app.js 8001
