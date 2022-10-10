import datetime
import logging
import requests

import azure.functions as func


URL = 'https://prod-06.centralus.logic.azure.com:443/workflows/4ae6457913624f3ab4797a864b7f6fe5/triggers/manual/paths/invoke?api-version=2016-10-01&sp=%2Ftriggers%2Fmanual%2Frun&sv=1.0&sig=eMAVLP0LL0oiw7ToYtGUj9trUOikd5GjZq4b6MV3EAw'

def main(mytimer: func.TimerRequest) -> None:
    utc_timestamp = datetime.datetime.utcnow().replace(tzinfo=datetime.timezone.utc).isoformat()

    if datetime.datetime.utcnow().hour == 8:
        requests.post(url = URL, json = "on")
    elif datetime.datetime.utcnow().hour == 20:
        requests.post(url = URL, json = "off")
    else:
        logging.error('Exact hour could not be read. Did not change the machine state.')

    if mytimer.past_due:
        logging.info('The timer is past due!')

    logging.info('Python timer trigger function ran at %s', utc_timestamp)
