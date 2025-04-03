FROM debian:bookworm-slim

ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update -y && \
    apt install -y --no-install-recommends software-properties-common && \
    echo "deb [signed-by=/usr/share/keyrings/debian-archive-keyring.gpg] http://deb.debian.org/debian bookworm non-free non-free-firmware" | tee /etc/apt/sources.list.d/non-free.list && \
    dpkg --add-architecture i386 && \
    apt-get update && \
    echo steam steam/question select "I AGREE" | debconf-set-selections && \
    apt-get install --no-install-recommends -y \
    steamcmd && \
    /usr/games/steamcmd +quit && \
    rm -rf /var/lib/apt/lists/*

RUN apt-get update -y && \
    apt-get install -y --no-install-recommends \
    openssh-server && \
    rm -rf /var/lib/apt/lists/* && \
    mkdir -p /run/sshd && \
    chmod 755 /run/sshd && \
    echo "ForceCommand internal-sftp -d /satisfactory" >> /etc/ssh/sshd_config

# Create 'steam' user with the password 'steam'
RUN adduser --gecos '' --disabled-password steam && echo "steam:steam" | chpasswd

# Start vsftpd as root and FactoryServer.sh as steam
CMD ["/bin/bash", "-c", "/usr/sbin/sshd & su - steam -c '/satisfactory/FactoryServer.sh'"]
