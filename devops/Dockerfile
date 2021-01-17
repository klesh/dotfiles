FROM lachlanevenson/k8s-kubectl:v1.20.1
RUN sed -i 's|dl-cdn.alpinelinux.org|mirrors.aliyun.com|g' /etc/apk/repositories
RUN apk update --no-cache \
    && apk add --update --no-cache curl \
    && rm -rf /var/cache/apk/*
WORKDIR /opt/devops
ADD bin .
ENV PATH=/opt/devops:$PATH
ENTRYPOINT ["/usr/bin/env"]
CMD ["ls"]
