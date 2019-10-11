FROM node:alpine

RUN npm i -g yarn

COPY ./app /opt/app
WORKDIR /opt/app
RUN yarn

ENTRYPOINT ["node", "/opt/app/app.js"]
