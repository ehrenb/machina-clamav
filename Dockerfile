FROM behren/machina-base-ubuntu:latest

ENV DEBIAN_FRONTEND noninteractive

RUN apt update && \
    apt -y install clamav-daemon vim
    
# clamav
# https://github.com/Cisco-Talos/clamav/blob/main/etc/clamd.conf.sample
# added DetectPUA

# https://github.com/Cisco-Talos/clamav/blob/main/etc/freshclam.conf.sample
# added LogTime

RUN cp /etc/clamav/clamd.conf /etc/clamav/clamd.conf.bak
RUN cp /etc/clamav/freshclam.conf /etc/clamav/freshclam.conf.bak

# COPY clamd.conf /etc/clamav/clamd.conf
# COPY freshclam.conf /etc/clamav/freshclam.conf

# RUN sed -e "s|^\(Example\)|\# \1|" \
#         -e "s|.*\(PidFile\) .*|\1 /tmp/clamd.pid|" \
#         -e "s|.*\(LocalSocket\) .*|\1 /tmp/clamd.sock|" \
#         -e "s|.*\(TCPSocket\) .*|\1 3310|" \
#         -e "s|.*\(TCPAddr\) .*|#\1 127.0.0.1|" \
#         -e "s|.*\(User\) .*|\1 clamav|" \
#         -e "s|^\#\(LogFile\) .*|\1 /var/log/clamav/clamd.log|" \
#         -e "s|^\#\(LogTime\).*|\1 yes|" \
#         -e "s|^\#\(DetectPUA\).*|\1 yes|" \                         
#         "/etc/clamav/clamd.conf.bak" > "/etc/clamav/clamd.conf" && \
#     sed -e "s|^\(Example\)|\# \1|" \
#         -e "s|.*\(PidFile\) .*|\1 /tmp/freshclam.pid|" \
#         -e "s|.*\(DatabaseOwner\) .*|\1 clamav|" \
#         -e "s|^\#\(UpdateLogFile\) .*|\1 /var/log/clamav/freshclam.log|" \
#         -e "s|^\#\(LogTime\).*|\1 yes|" \
#         -e "s|^\#\(NotifyClamd\).*|\1 /etc/clamav/clamd.conf|" \
#         -e "s|^\#\(ScriptedUpdates\).*|\1 yes|" \
#         "/etc/clamav/freshclam.conf.bak" > "/etc/clamav/freshclam.conf" || \
#     exit 1



COPY requirements.txt /tmp/
RUN pip3 install -r /tmp/requirements.txt
RUN rm /tmp/requirements.txt

COPY ClamAVAnalysis.json /schemas/

COPY src /machina/src

USER clamav

# update definitions using freshclam,
# at bottom of file to ensure it gets run as much as possible
# when builds are triggered - but this should also be done at service-start-time
# RUN freshclam



# custom clamd.conf ??
# https://github.com/Cisco-Talos/clamav-docker/blob/main/clamav/1.3/debian/Dockerfile