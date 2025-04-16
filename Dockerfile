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
    /usr/games/steamcmd +quit

RUN apt-get install -y --no-install-recommends \
    net-tools \
    psmisc \
    cron

RUN apt-get install -y --no-install-recommends \
    openssh-server && \
    rm -rf /var/lib/apt/lists/* && \
    mkdir -p /run/sshd && \
    chmod 755 /run/sshd && \
    echo "ForceCommand internal-sftp -d /satisfactory" >> /etc/ssh/sshd_config

# Create 'steam' user with the password 'steam'
RUN adduser --gecos '' --disabled-password steam && echo "steam:steam" | chpasswd

COPY update.sh /usr/games/update.sh

# Add the cron job
RUN echo "0 * * * * /usr/games/update.sh" >> /var/spool/cron/crontabs/root

COPY start_factory.sh /usr/games/start_factory.sh
RUN chmod +x /usr/games/start_factory.sh

ENTRYPOINT ["/usr/games/start_factory.sh"]
