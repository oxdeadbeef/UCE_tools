import requests
import logging

logger = logging.getLogger(__name__)
logger.setLevel(logging.INFO)

def queryJsonEndpoint(uri, payload={}):

    try:
        res = requests.get(uri, params=payload)
    except requests.exceptions.RequestException as e:
        logger.error(e.response.text)
        return None

    if res.status_code == requests.codes.ok:
        if 'application/json' in res.headers.get('content-type'):
            return res.json()
        else:
            logger.error('{} was not JSON'.format(uri))
            return None