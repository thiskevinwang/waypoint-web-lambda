FROM python:3.10-alpine
# READINESS_CHECK_PORT and PORT are used by https://github.com/aws-samples/aws-lambda-adapter/blob/main/src/main.rs
ENV READINESS_CHECK_PORT=7531
ENV PORT=7531
COPY --from=ghcr.io/thiskevinwang/aws-lambda-adapter:0.3.2 /lambda-adapter /opt/extensions/lambda-adapter

# copy source files to image
COPY ./requirements.txt /app/requirements.txt
COPY ./app.py /app/app.py

# TODO: use multi-stage build to cache requirements

# install requirements
WORKDIR /app
RUN pip3 install -r requirements.txt

# run the app
CMD [ "python3", "app.py" ]
