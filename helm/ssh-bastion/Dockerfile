FROM alpine:3.12.0

ENV TERM=xterm-256color

RUN apk add --no-cache openssh-server-pam bash && \
    mkdir /var/run/sshd

VOLUME ["/keys"]

COPY start_ssh_server.sh /usr/bin/start_ssh_server.sh
COPY config/sshd_config /etc/ssh/sshd_config

RUN chmod 700 /usr/bin/start_ssh_server.sh

RUN ssh-keygen -A
RUN chmod -R 700 /etc/ssh

ENTRYPOINT ["/usr/bin/start_ssh_server.sh"]