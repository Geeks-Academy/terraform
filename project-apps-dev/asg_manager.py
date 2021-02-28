import boto3
import os
import json
import logging
import urllib3
from datetime import date, timedelta
from calendar import monthrange

def lambda_handler(event, context):
    
    
    return {
        'statusCode': 200,
        'body': json.dumps('Hello from Lambda!')
    }
