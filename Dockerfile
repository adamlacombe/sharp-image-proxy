FROM node:14

WORKDIR /usr/src/app

COPY package.json ./package.json

RUN npm install

COPY . .

RUN npm run build

CMD [ "npm", "run", "start" ]
