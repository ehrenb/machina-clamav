import json

from machina.core.worker import Worker

import clamd

class ClamAVAnalysis(Worker):
    types = ['*']
    next_queues = []

    def __init__(self, *args, **kwargs):
        super(ClamAVAnalysis, self).__init__(*args, **kwargs)
        self.cd = clamd.ClamdUnixSocket('/tmp/clamd.sock')
        
        if self.cd.ping() != 'PONG':
            raise Exception('ClamAV ping failed')
        self.logger.info(f'ClamAV version: {self.cd.version()}')
        
        
    def callback(self, data, properties):
        data = json.loads(data)

        # resolve path
        target = self.get_binary_path(data['ts'], data['hashes']['md5'])
        self.logger.info(f"resolved path: {target}")

        result = self.cd.scan(target)

        self.logger.info(result)
        # self.logger.info(reason)
        