FROM gelbpunkt/gateway-proxy:x86-64

COPY ./config.json /config.json

EXPOSE 7878

CMD ["/gateway-proxy"]
