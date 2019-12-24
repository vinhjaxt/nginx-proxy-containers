FROM node:alpine

# RUN npm i -g yarn

RUN apk add --no-cache tzdata
ENV TZ Asia/Ho_Chi_Minh
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

RUN mkdir 755 /opt/app
WORKDIR /opt/app
COPY ./app/package.json /opt/app/package.json
RUN yarn install --production --no-lockfile
COPY ./app /opt/app

ENV NODE_PATH=/usr/local/lib/node_modules:/usr/local/share/.config/yarn/global/node_modules

RUN adduser --disabled-password --gecos "" user
COPY ./entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh
ENTRYPOINT ["/entrypoint.sh"]
