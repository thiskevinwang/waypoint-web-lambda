# > **Warning**: Runtime exited with error: exit status 254
# > This error is caused by Node 16.15.1; Downgrade to 16.14.2
# > See https://repost.aws/questions/QUtlb2BYIEQjyirCUWspC-CQ/exit-254-lambda-error-with-no-extra-explanations
FROM node:16.14-alpine as COMPILER
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

FROM node:16.14-alpine
WORKDIR /usr/app
COPY --from=COMPILER /usr/app/.next /usr/app/.next
# `public` dir should live at the same level as `.next`
COPY --from=COMPILER /usr/app/public /usr/app/public
COPY --from=COMPILER /usr/app/package*.json /usr/app
COPY --from=COMPILER /usr/app/node_modules /usr/app/node_modules

# READINESS_CHECK_PORT and PORT are used by https://github.com/aws-samples/aws-lambda-adapter/blob/main/src/main.rs
ENV READINESS_CHECK_PORT=7531
ENV PORT=7531
COPY --from=ghcr.io/thiskevinwang/aws-lambda-adapter:0.3.2 /lambda-adapter /opt/extensions/lambda-adapter
CMD ["npm", "start", "--", "--port", "$PORT"]