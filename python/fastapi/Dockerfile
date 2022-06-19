FROM python:3.10-alpine
# READINESS_CHECK_PORT and PORT are used by https://github.com/aws-samples/aws-lambda-adapter/blob/main/src/main.rs
ENV READINESS_CHECK_PORT=7531
ENV PORT=7531
COPY --from=ghcr.io/thiskevinwang/aws-lambda-adapter:0.3.2 /lambda-adapter /opt/extensions/lambda-adapter

COPY ./requirements.txt /app/requirements.txt
COPY ./main.py /app/main.py

# TODO: use multi-stage build to cache requirements

# install requirements
WORKDIR /app
RUN pip3 install --no-cache-dir --upgrade -r requirements.txt

# run the app
CMD ["sh", "-c", "uvicorn main:app --host 0.0.0.0 --port $PORT"]
# **Note**: If you want docker to expand variables in `CMD`,
# you need to use `sh -c`.

# If running behind a proxy like Nginx or Traefik add --proxy-headers
# CMD ["uvicorn", "app.main:app", "--host", "0.0.0.0", "--port", "80", "--proxy-headers"]