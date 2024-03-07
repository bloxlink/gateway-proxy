FROM gelbpunkt/gateway-proxy:x86-64

COPY ./config.json /config.json

CMD ["/gateway-proxy"]
