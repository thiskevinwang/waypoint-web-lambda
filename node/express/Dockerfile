# docker build -t node-express:latest .
# docker run --rm --tty -p 8080:8080 node-express:latest

###########################
#      Dependencies       #
###########################
# - This stage will be cached unless `package.json` changes
# - This will drastically bypass the typically slow install process
FROM node:16-alpine as DEPS
WORKDIR /usr/app
COPY package.json ./
# COPY package*.json ./
# Don't copy package-lock.json because of platform errors
RUN npm install -g npm@latest
RUN npm i

###############################
#          Compiler           #
###############################
# - Compile TS to JS
FROM node:16-alpine as COMPILER
WORKDIR /usr/app
COPY --from=DEPS /usr/app/node_modules ./node_modules
COPY package.json ./
COPY tsconfig*.json ./
COPY app.ts ./
COPY index.ts ./
RUN npm run build
RUN npm prune

###################
#   Application   #
###################
FROM node:16-alpine as APP

######################
# aws-lambda-adapter #
######################
# - READINESS_CHECK_PORT and PORT
#   are used by https://github.com/aws-samples/aws-lambda-adapter/blob/main/src/main.rs
ENV READINESS_CHECK_PORT=3005
ENV PORT=3005
COPY --from=public.ecr.aws/awsguru/aws-lambda-adapter:0.3.2 /lambda-adapter /opt/extensions/lambda-adapter

# Default env vars; These should be overridden by the environment
ENV POSTGRES_USER=postgres
ENV POSTGRES_PASSWORD=postgres
ENV POSTGRES_DB=postgres
ENV POSTGRES_PORT=5432
ENV POSTGRES_HOST=localhost

COPY --from=COMPILER /usr/app/out ./out
COPY --from=COMPILER /usr/app/package*.json ./
COPY --from=COMPILER /usr/app/node_modules ./node_modules

CMD ["npm", "start"]


# # https://github.com/GoogleContainerTools/distroless/blob/main/examples/nodejs/Dockerfile
# # FROM gcr.io/distroless/nodejs:16
# WORKDIR /usr/app
# COPY --from=BUILDER /usr/app ./
# CMD ["index.js"]