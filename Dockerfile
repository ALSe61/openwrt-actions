FROM ubuntu:latest
LABEL maintainer=ALSe61
ENV USER=user
ENV TZ=Asia/Yekaterinburg
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone
RUN apt update -q -y && \
    apt install -q -y sudo bash wget megatools curl gettext dialog apt-utils build-essential asciidoc binutils bzip2 \
    git libncurses5-dev libz-dev patch python3-distutils python3 python3-setuptools gawk \
    python3-dev unzip zlib1g-dev libc6-dev-i386 subversion flex uglifyjs gcc p7zip-full \
    libssl-dev texinfo libglib2.0-dev xmlto qemu-utils upx libelf-dev autoconf \
    automake libtool autopoint device-tree-compiler g++ antlr3 gperf swig  \
    rsync ccache ecj fastjar file xsltproc time tmate java-propose-classpath libmnl-dev \
    openssh-server etherwake libnfnetlink-dev mc libncursesw5-dev python2.7-dev && \
    apt clean -y && \
    rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*
RUN useradd -m $USER && \
    echo "$USER:$USER" | chpasswd && \
    echo "$USER ALL=(ALL) NOPASSWD: ALL" > /etc/sudoers.d/$USER && \
    chmod 440 /etc/sudoers.d/$USER
USER $USER
WORKDIR /home/$USER
RUN git config --global user.name "$USER" && git config --global user.email "$USER@example.com"

