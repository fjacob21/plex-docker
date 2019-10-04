FROM debian:latest
ENV PLEX_DOWNLOAD="https://downloads.plex.tv/plex-media-server-new"
ENV PLEX_MEDIA_SERVER_APPLICATION_SUPPORT_DIR='/var/lib/plexmediaserver/Library/Application Support'
ENV PLEX_MEDIA_SERVER_HOME=/usr/lib/plexmediaserver
ENV PLEX_MEDIA_SERVER_MAX_PLUGIN_PROCS=6
ENV PLEX_MEDIA_SERVER_TMPDIR=/tmp
ENV PLEX_ARCH="armhf"
ENV PLEX_MEDIA_SERVER_INFO_VENDOR="Docker"
ENV PLEX_MEDIA_SERVER_INFO_MODEL="armv7l"
ENV PLEX_MEDIA_SERVER_INFO_DEVICE="Docker Container (LinuxServer.io)"
ENV PLEX_MEDIA_SERVER_USER="abc"
ENV PLEX_MEDIA_SERVER_INFO_PLATFORM_VERSION="1.0"
ENV LD_LIBRARY_PATH=/usr/lib/plexmediaserver/lib
RUN apt update && apt install wget curl udev jq vim -y
RUN echo "**** Udevadm hack ****" && \
    mv /sbin/udevadm /sbin/udevadm.bak && \
    echo "exit 0" > /sbin/udevadm && \
    chmod +x /sbin/udevadm 
RUN export PLEX_RELEASE=$(curl -sX GET 'https://plex.tv/api/downloads/5.json' | jq -r '.computer.Linux.version') && \
    echo "Downloading " ${PLEX_DOWNLOAD}/${PLEX_RELEASE}/debian/plexmediaserver_${PLEX_RELEASE}_${PLEX_ARCH}.deb && \
    curl -o /tmp/plexmediaserver.deb -L ${PLEX_DOWNLOAD}/${PLEX_RELEASE}/debian/plexmediaserver_${PLEX_RELEASE}_${PLEX_ARCH}.deb
#RUN wget https://downloads.plex.tv/plex-media-server-new/1.16.5.1554-1e5ff713d/debian/plexmediaserver_1.16.5.1554-1e5ff713d_armhf.deb
#RUN dpkg -i plexmediaserver_1.16.5.1554-1e5ff713d_armhf.deb
RUN dpkg -i /tmp/plexmediaserver.deb
RUN mv /sbin/udevadm.bak /sbin/udevadm && \
 echo "**** cleanup ****" && \
 apt-get clean && \
 rm -rf \
	/etc/default/plexmediaserver \
	/tmp/* \
	/var/lib/apt/lists/* \
	/var/tmp/*
EXPOSE 32400 32400/udp 32469 32469/udp 5353/udp 1900/udp
COPY run.sh /
ENTRYPOINT ["/run.sh"]

