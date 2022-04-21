FROM hashicorp/vault:1.9.3

RUN apk add --no-cache su-exec dumb-init jq curl 

COPY run.sh ./

CMD ./run.sh