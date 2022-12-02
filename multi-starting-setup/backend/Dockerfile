FROM node:14

WORKDIR /app

COPY package.json .

RUN npm install

COPY . .

ARG DEFAULT_PORT=80

ENV PORT $DEFAULT_PORT
ENV DB_USER=root
ENV DB_PASS=secret

EXPOSE $PORT

CMD [ "npm", "start" ]