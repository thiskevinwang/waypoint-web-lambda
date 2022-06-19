# docker build -t node-next:latest .
# docker run --rm --tty -p 5000:5000 node-next:latest
FROM node:16-alpine as COMPILER
WORKDIR /usr/app
# COPY package*.json ./
# Don't copy package-lock.json because of platform errors
COPY package.json ./
COPY tsconfig*.json ./
RUN npm install -g npm@latest
RUN npm i
# COPY . ./
COPY pages pages
COPY public public
COPY styles styles
RUN npm run build

FROM node:16-alpine
COPY --from=COMPILER /usr/app/.next .next
# `public` dir should live at the same level as `.next`
COPY public /public
COPY --from=COMPILER /usr/app/package*.json /
COPY --from=COMPILER /usr/app/node_modules /node_modules
# READINESS_CHECK_PORT and PORT are used by https://github.com/aws-samples/aws-lambda-adapter/blob/main/src/main.rs
ENV READINESS_CHECK_PORT=7531
ENV PORT=7531
COPY --from=ghcr.io/thiskevinwang/aws-lambda-adapter:0.3.2 /lambda-adapter /opt/extensions/lambda-adapter
CMD ["npm", "start", "--", "--port", "$PORT"]

# # https://github.com/GoogleContainerTools/distroless/blob/main/examples/nodejs/Dockerfile
# # FROM gcr.io/distroless/nodejs:16
# WORKDIR /usr/app
# COPY --from=BUILDER /usr/app ./
# CMD ["index.js"]