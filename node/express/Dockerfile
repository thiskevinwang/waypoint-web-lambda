FROM node:16-alpine as COMPILER
WORKDIR /usr/app
COPY package*.json ./
COPY tsconfig*.json ./
RUN npm install
COPY . ./
RUN npm run tsc

FROM node:16-alpine as BUILDER
WORKDIR /usr/app
COPY --from=COMPILER /usr/app/package*.json ./
COPY --from=COMPILER /usr/app/out ./
RUN npm install --only=production

# https://github.com/GoogleContainerTools/distroless/blob/main/examples/nodejs/Dockerfile
FROM gcr.io/distroless/nodejs:16
WORKDIR /usr/app
COPY --from=BUILDER /usr/app ./
CMD ["index.js"]