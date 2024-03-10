FROM behren/machina-base-ubuntu:latest

RUN apt update && \
    apt install clamav

COPY requirements.txt /tmp/
RUN pip3 install -r /tmp/requirements.txt
RUN rm /tmp/requirements.txt

COPY ClamAVAnalysis.json /schemas/

COPY src /machina/src

# update definitions using freshclam,
# at bottom of file to ensure it gets run as much as possible
# when builds are triggered - but this should also be done at service-start-time
RUN freshclam