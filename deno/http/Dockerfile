# docker build -t deno-http:latest .
# docker run --rm --tty -p 8000:8000 deno-http:latest
## This is linux/amd64
FROM denoland/deno:latest

# The port that your application listens to.
EXPOSE 8000
ENV READINESS_CHECK_PORT=8000
ENV PORT=8000
COPY --from=public.ecr.aws/awsguru/aws-lambda-adapter:0.3.2 /lambda-adapter /opt/extensions/lambda-adapter

WORKDIR /app

# Prefer not to run as root.
USER deno

# Cache the dependencies as a layer (the following two steps are re-run only when deps.ts is modified).
# Ideally cache deps.ts will download and compile _all_ external files used in main.ts.
COPY deps.ts .
RUN deno cache deps.ts

# These steps will be re-run upon each file change in your working directory:
ADD . .
# Compile the main app so that it doesn't need to be compiled each startup/entry.
RUN deno cache main.ts

CMD ["run", "--allow-net", "--allow-env", "main.ts"]