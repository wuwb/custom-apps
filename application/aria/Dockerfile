FROM node:12.10.0-alpine
LABEL AUTHOR soulteary

ADD webui-aria2/package.json /app/package.json
ADD webui-aria2/package-lock.json /app/package-lock.json

WORKDIR /app

RUN npm i --registry=http://r.cnpmjs.org/

ADD webui-aria2/ /app

ADD ./patches/configuration.js /app/src/js/services/configuration.js
ADD ./patches/rpc.js /app/src/js/services/rpc/rpc.js

RUN npm run build

RUN npm i http-proxy --registry=http://r.cnpmjs.org/
ADD ./patches/node-server.js /app/node-server.js

CMD [ "node", "./node-server.js" ]
