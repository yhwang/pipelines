FROM alpine

RUN apk add --update --no-cache curl jq bash

COPY kfp-executor-driver.sh /kfp-executor-driver.sh

CMD ["/kfp-executor-driver.sh"]
