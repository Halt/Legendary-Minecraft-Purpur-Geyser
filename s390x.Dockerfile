# Minecraft Java Purpur Server + Geyser + Floodgate Docker Container
# Author: James A. Chambers - https://jamesachambers.com/docker-minecraft-purpur-geyser-server/
# GitHub Repository: https://github.com/TheRemote/Legendary-Minecraft-Purpur-Geyser

# Use Ubuntu rolling version for builder
FROM ubuntu:rolling AS builder

# Update apt
RUN apt-get update && DEBIAN_FRONTEND=noninteractive apt-get install qemu-user-static binfmt-support apt-utils -yqq && rm -rf /var/cache/apt/*

# Use Ubuntu rolling version
FROM --platform=linux/s390x ubuntu:rolling

# Add QEMU
COPY --from=builder /usr/bin/qemu-s390x-static /usr/bin/

# Fetch dependencies
RUN apt update && DEBIAN_FRONTEND=noninteractive apt-get install openjdk-19-jre-headless systemd-sysv tzdata sudo curl unzip net-tools gawk openssl findutils pigz libcurl4 libc6 libcrypt1 apt-utils libcurl4-openssl-dev ca-certificates binfmt-support nano -yqq && rm -rf /var/cache/apt/*

# Set port environment variable
ENV Port=25565

# Set Bedrock port environment variable
ENV BedrockPort=19132

# Optional maximum memory Minecraft is allowed to use
ENV MaxMemory=

# Optional Minecraft Version override
ENV Version="1.19.4"

# Optional Timezone
ENV TZ="America/Denver"

# Optional folder to ignore during backup operations
ENV NoBackup=""

# Number of rolling backups to keep
ENV BackupCount=10

# Optional switch to skip permissions check
ENV NoPermCheck=""

# Optional switch to tell curl to suppress the progress meter which generates much less noise in the logs
ENV QuietCurl=""

# IPV4 Ports
EXPOSE 25565/tcp
EXPOSE 19132/tcp
EXPOSE 19132/udp

# Copy scripts to minecraftbe folder and make them executable
RUN mkdir /scripts
COPY *.sh /scripts/
COPY *.yml /scripts/
COPY server.properties /scripts/
RUN chmod -R +x /scripts/*.sh

# Set entrypoint to start.sh script
ENTRYPOINT ["/bin/bash", "/scripts/start.sh"]
