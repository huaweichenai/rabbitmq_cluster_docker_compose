FROM haproxy:alpine

COPY ./config/haproxy.cfg /usr/local/etc/haproxy/haproxy.cfg

USER root
COPY docker-entrypoint.sh /usr/local/bin/
RUN chmod +x /usr/local/bin/docker-entrypoint.sh && \
    chown -R haproxy:haproxy /usr/local/etc/haproxy

ENTRYPOINT ["docker-entrypoint.sh"]

USER haproxy
CMD ["haproxy", "-f", "/usr/local/etc/haproxy/haproxy.cfg"]
