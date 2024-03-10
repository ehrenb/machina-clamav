# machina-clamav

* Minor configuration changes are required to get `clamd` running.  These configurations are found in the top level `machina/configs/workers/clamav/clamd.conf` and `machina/configs/workers/clamav/freshclam.conf`

* in compose, `freshclam -d` is used to frequently obtain new db updates
    - db is volume mounted

# references


* Python clamd socket comms (https://github.com/graingert/python-clamd)
* sample configs
    - https://github.com/Cisco-Talos/clamav/blob/main/etc/clamd.conf.sample
    - https://github.com/Cisco-Talos/clamav/blob/main/etc/freshclam.conf.sample