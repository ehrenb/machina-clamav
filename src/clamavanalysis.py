import json

from machina.core.worker import Worker

class ClamAVAnalysis(Worker):
    types = ['*']
    next_queues = []

    def __init__(self, *args, **kwargs):
        super(ClamAVAnalysis, self).__init__(*args, **kwargs)

    def callback(self, data, properties):
        data = json.loads(data)

        # resolve path
        target = self.get_binary_path(data['ts'], data['hashes']['md5'])
        self.logger.info(f"resolved path: {target}")

