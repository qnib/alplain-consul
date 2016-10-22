FROM qnib/alplain-init

ARG CONSUL_VER=0.7.0
ARG CT_VER=0.16.0
ENV CONSUL_BIN=/opt/qnib/consul/bin/consul \
    PATH=${PATH}:/opt/qnib/consul/bin/

RUN apk --no-cache add curl unzip jq nmap \
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
 && apk --no-cache del unzip
ADD etc/consul.d/agent.json /etc/consul.d/
RUN wget -qO /usr/local/bin/go-github https://github.com/qnib/go-github/releases/download/0.2.2/go-github_0.2.2_MuslLinux \
 && chmod +x /usr/local/bin/go-github \
 && echo "# download: $(/usr/local/bin/go-github rLatestUrl --ghorg qnib --ghrepo consul-content --regex 'consul.tar$' |head -n1)" \
 && wget -qO - $(/usr/local/bin/go-github rLatestUrl --ghorg qnib --ghrepo consul-content --regex 'consul.tar$' |head -n1) |tar xf - -C /opt/qnib/ \
 && rm -f /usr/local/bin/go-github
VOLUME ["/opt/qnib/consul/bin/", "/etc/consul.d"]
CMD ["/opt/qnib/consul/bin/start.sh"]
