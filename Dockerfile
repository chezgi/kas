# This image builds Yocto jobs using the kas tool

FROM debian:bullseye-slim

ARG DEBIAN_FRONTEND=noninteractive

RUN apt-get update && \
    apt-get install -y locales && \
    localedef -i en_US -c -f UTF-8 -A /usr/share/locale/locale.alias en_US.UTF-8
ENV LANG=en_US.utf8

RUN apt-get install --no-install-recommends -y \
        gawk wget git-core diffstat unzip texinfo \
        build-essential chrpath socat cpio python python3 python3-pip python3-pexpect \
        xz-utils debianutils iputils-ping python3-git python3-jinja2 libegl1-mesa libsdl1.2-dev \
        pylint3 xterm \
        python3-setuptools python3-wheel python3-yaml python3-distro python3-jsonschema \
        gosu lsb-release file vim less procps tree tar bzip2 zstd bc tmux libncurses-dev \
        python3-newt pigz lz4 bash-completion liblz4-tool python3-subunit mesa-common-dev \
        dosfstools mtools parted gcc-multilib syslinux g++-multilib \
        git-lfs mercurial iproute2 ssh-client curl rsync gnupg awscli sudo && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

RUN wget -nv -O /usr/bin/oe-git-proxy "http://git.yoctoproject.org/cgit/cgit.cgi/poky/plain/scripts/oe-git-proxy" && \
    chmod +x /usr/bin/oe-git-proxy
ENV GIT_PROXY_COMMAND="oe-git-proxy" \
    NO_PROXY="*"

RUN groupadd -o --gid 1000 builder
RUN useradd -o --uid 1000 --gid 1000 --create-home --home-dir /builder builder

RUN echo "builder ALL=NOPASSWD: ALL" > /etc/sudoers.d/builder-nopasswd && \
    chmod 660 /etc/sudoers.d/builder-nopasswd

RUN echo "Defaults env_keep += \"ftp_proxy http_proxy https_proxy no_proxy\"" \
    > /etc/sudoers.d/env_keep && chmod 660 /etc/sudoers.d/env_keep

COPY . /kas
RUN pip3 --proxy=$https_proxy install --no-deps /kas 

# install libthemis
RUN wget -qO - https://pkgs-ce.cossacklabs.com/gpg | apt-key add -
RUN echo "deb https://pkgs-ce.cossacklabs.com/stable/debian bullseye main" | \
    tee /etc/apt/sources.list.d/cossacklabs.list
RUN apt update && \
    apt install -y libthemis-dev

WORKDIR /WorkingDir/kas
ENTRYPOINT ["/kas/container-entrypoint"]
