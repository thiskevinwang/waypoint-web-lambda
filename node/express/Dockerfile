# > **Warning**: Runtime exited with error: exit status 254
# > This error is caused by Node 16.15.1; Downgrade to 16.14.2
# > See https://repost.aws/questions/QUtlb2BYIEQjyirCUWspC-CQ/exit-254-lambda-error-with-no-extra-explanations
FROM node:16.14-alpine as DEPS
WORKDIR /usr/app
COPY package.json ./
RUN npm i

FROM node:16.14-alpine as COMPILER
COPY --from=DEPS /usr/app/node_modules /usr/app/node_modules
WORKDIR /usr/app

# COPY package*.json ./
# Don't copy package-lock.json because of platform errors
COPY package.json ./
COPY tsconfig*.json ./
COPY app.ts ./
COPY index.ts ./
RUN npm run build

# https://github.com/GoogleContainerTools/distroless/blob/main/examples/nodejs/Dockerfile
# FROM gcr.io/distroless/nodejs:16
FROM node:16.14-alpine

# READINESS_CHECK_PORT and PORT are used by https://github.com/aws-samples/aws-lambda-adapter/blob/main/src/main.rs
ENV READINESS_CHECK_PORT=3005
ENV PORT=3005
# Note: pass the "-x86_64" suffix to avoid strange errors when using remote runners on K8s
# Error: fork/exec /opt/extensions/lambda-adapter: exec format error Extension.LaunchError
COPY --from=public.ecr.aws/awsguru/aws-lambda-adapter:0.3.2-x86_64 /lambda-adapter /opt/extensions/lambda-adapter
# COPY --from=ghcr.io/thiskevinwang/aws-lambda-adapter:0.3.2 /lambda-adapter /opt/extensions/lambda-adapter

COPY --from=COMPILER /usr/app/out ./out
COPY --from=COMPILER /usr/app/package*.json ./
COPY --from=COMPILER /usr/app/node_modules ./node_modules

# > **Warning**: If using distroless image and CMD "out/index.js",
# > SIGINT (Ctrl+C) does not seem to be detected.
# CMD ["out/index.js"]
CMD ["npm", "start"]
