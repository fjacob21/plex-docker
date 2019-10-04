docker run -it --network host --name plex -v /mnt/gv0/plexmediaserver:/var/lib/plexmediaserver -v/mnt/gv0:/mnt/gv0  -d --restart unless-stopped  plex
