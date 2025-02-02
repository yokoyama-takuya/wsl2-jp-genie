FROM ubuntu:24.04

ENV DEBIAN_FRONTEND=noninteractive

ARG USERNAME=user
ARG PASSWORD=user
ARG ROOT_PASSWORD=root

RUN echo "root:${ROOT_PASSWORD}" |  chpasswd  && \
    useradd -m --groups sudo --shell /bin/bash ${USERNAME} && \
    echo "${USERNAME}:${PASSWORD}" | chpasswd

COPY default.sh ./

RUN cat default.sh >> /home/${USERNAME}/.bashrc && \
    touch /etc/wsl.conf && \
    echo -n "[user]\n\
default=${USERNAME}\n\
[boot]\n\
systemd=true\n" >> /etc/wsl.conf

RUN apt-get update && apt-get upgrade -y && apt-get install -y \
    wget \
    curl \
    gnupg \
    sudo \
    vim \
    git \
    xclip \
    x11-apps \
    dbus-x11 \
    language-pack-ja \
    fcitx5 \
    fcitx5-mozc

RUN update-locale LANG=ja_JP.UTF8 && \
    ln -sf /usr/share/zoneinfo/Asia/Tokyo /etc/localtime

CMD ["/bin/bash"]