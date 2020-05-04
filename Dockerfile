FROM alpine:3.9

RUN addgroup -g 1000 newman \
	&& adduser -u 1000 -G node -s /bin/sh -D node \
	&& apk add --update nodejs nodejs-npm jq\
	&& npm install -g newman \
	&& npm install -g newman-reporter-smoke-break \

USER node

COPY ./runner.sh runner.sh
RUN chmod +x /archive.sh
