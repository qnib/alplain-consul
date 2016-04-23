FROM qnib/alpn-base

ENV CONSUL_VER=0.6.4 \
    CT_VER=0.14.0

RUN apk add --update curl unzip jq nmap \
 && curl -fso /tmp/consul.zip https://releases.hashicorp.com/consul/${CONSUL_VER}/consul_${CONSUL_VER}_linux_amd64.zip \
 && mkdir -p /opt/qnib/consul/bin/ \
 && cd /opt/qnib/consul/bin/ \
 && unzip /tmp/consul.zip \
 && rm -f /tmp/consul.zip \
 && mkdir -p /opt/consul-web-ui \
 && curl -Lso /tmp/consul-web-ui.zip https://releases.hashicorp.com/consul/${CONSUL_VER}/consul_${CONSUL_VER}_web_ui.zip \
 && cd /opt/consul-web-ui \
 && unzip /tmp/consul-web-ui.zip \
 && rm -f /tmp/consul-web-ui.zip \
 && curl -Lso /tmp/consul-template.zip https://releases.hashicorp.com/consul-template/${CT_VER}/consul-template_${CT_VER}_linux_amd64.zip \
 && cd /opt/qnib/consul/bin/ \
 && unzip /tmp/consul-template.zip \
 && apk del unzip \
 && rm -f /var/cache/apk/*
ADD etc/consul.d/agent.json /etc/consul.d/
ADD opt/qnib/consul/bin/start.sh /opt/qnib/consul/bin/
VOLUME ["/opt/qnib/consul/bin/", "/etc/consul.d"]
CMD ["/opt/qnib/consul/bin/start.sh"]
