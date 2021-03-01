import boto3
import os
import json
import logging
import urllib3
from datetime import date, timedelta
from calendar import monthrange

def lambda_handler(event, context):
    UP_DESIRED_CAPACITY = os.environ['UP_COUNT']
    DOWN_DESIRED_CAPACITY = os.environ['DOWN_COUNT']
    
    client = boto3.client('autoscaling')
    
    if event['type'] == 'UP':
        DESIRED_CAPACITY = int(UP_DESIRED_CAPACITY)
    elif event['type'] == 'DOWN':
        DESIRED_CAPACITY = int(DOWN_DESIRED_CAPACITY)
    
    response = client.set_desired_capacity(
                    AutoScalingGroupName='programmers-only',
                    DesiredCapacity=DESIRED_CAPACITY,
                    HonorCooldown=False
                )
    
    return {
        'statusCode': 200,
        'body': response
    }
