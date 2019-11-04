FROM node:alpine

RUN npm i -g yarn

COPY ./app /opt/app
WORKDIR /opt/app
RUN yarn

ENV NODE_PATH=/usr/local/lib/node_modules:/usr/local/share/.config/yarn/global/node_modules

RUN adduser --disabled-password --gecos "" user
COPY ./entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh
ENTRYPOINT ["/entrypoint.sh"]
