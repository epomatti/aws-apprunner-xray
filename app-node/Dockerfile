# Credit: https://www.emmanuelgautier.com/blog/snippets/typescript-dockerfile

### Builder ###
FROM node:20 as builder

WORKDIR /usr/src/app
COPY package.json package-lock.json tsconfig.json ./

RUN npm install --frozen-lockfile
COPY . .
RUN npm run build

### Runtime ###
FROM node:20-slim

# Health check
RUN apt-get update
RUN apt-get install -y curl 

ENV NODE_ENV production
WORKDIR /usr/src/app

COPY package.json package-lock.json tsconfig.json ./
RUN npm install --production --frozen-lockfile
COPY --from=builder /usr/src/app/dist ./dist

CMD ["node", "dist/server.js" ]
