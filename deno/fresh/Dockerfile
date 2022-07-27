## This is linux/amd64
FROM denoland/deno:alpine-1.24.0
## ARM Deno image
# FROM lukechannings/deno:v1.24.0

# The port that your application listens to.
ENV READINESS_CHECK_PORT=8000
ENV PORT=8000
COPY --from=ghcr.io/thiskevinwang/aws-lambda-adapter:0.3.2 /lambda-adapter /opt/extensions/lambda-adapter

WORKDIR /app

# Prefer not to run as root.
USER deno

# Cache the dependencies as a layer (the following two steps are re-run only when deps.ts is modified).
# Ideally cache deps.ts will download and compile _all_ external files used in main.ts.
COPY islands ./islands
COPY routes ./routes
COPY static ./static
COPY utils ./utils
COPY deno.json .
# COPY dev.ts .
COPY fresh.gen.ts .
COPY import_map.json .
COPY main.ts .

ENV DENO_DIR=/tmp/.deno


# CMD ["task", "start"]
CMD ["run", "--allow-env", "--allow-net", "--allow-read", "--allow-write", "--allow-run", "main.ts"]
