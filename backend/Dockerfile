FROM alpine

ARG DAEMON

WORKDIR /app
EXPOSE 8080

COPY ./build/$DAEMON ./daemon-binary

CMD /app/daemon-binary --config=config.toml
