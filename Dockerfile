FROM node:14-alpine as COMPILER
WORKDIR /usr/app
COPY package*.json ./
COPY tsconfig*.json ./
RUN npm install
COPY . ./
RUN npm run tsc

FROM node:14-alpine as BUILDER
WORKDIR /usr/app
COPY --from=COMPILER /usr/app/package*.json ./
COPY --from=COMPILER /usr/app/out ./
RUN npm install --only=production

FROM gcr.io/distroless/nodejs:14
WORKDIR /usr/app
COPY --from=BUILDER /usr/app ./
USER 1000
CMD ["index.js"]