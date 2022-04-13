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
WORKDIR /var/task
COPY --from=COMPILER /usr/app/.next /var/task/.next
COPY --from=COMPILER /usr/app/package*.json /var/task/
COPY --from=COMPILER /usr/app/node_modules /var/task/node_modules
COPY --from=public.ecr.aws/awsguru/aws-lambda-adapter:0.3.2 /lambda-adapter /opt/extensions/lambda-adapter
EXPOSE 8080
CMD ["npm", "start", "--", "--port", "8080"]

# # https://github.com/GoogleContainerTools/distroless/blob/main/examples/nodejs/Dockerfile
# # FROM gcr.io/distroless/nodejs:16
# WORKDIR /usr/app
# COPY --from=BUILDER /usr/app ./
# CMD ["index.js"]