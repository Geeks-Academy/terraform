import boto3
import os
import json
import logging
import urllib3
from datetime import date, timedelta
from calendar import monthrange



def send_welcome_message(date, granularity, webhookURL):
    http = urllib3.PoolManager()
    
    slack_message = {
        'channel': "#aws_costs",
        'username': granularity + " AWS Cost Explorer",
        'icon_emoji': ':aws:',
        'text': 'I HOPE YOUR COSTS ARE LOW! \nThis is brand new report for: ' + '*' + date + '*'
    }

    encoded_msg = json.dumps(slack_message).encode('utf-8')
    resp = http.request('POST', webhookURL, body=encoded_msg)



def send_message(service_name, cost, granularity, color, webhookURL):
    http = urllib3.PoolManager()
    
    slack_message = {
        'channel': "#aws_costs",
        'username': granularity + " AWS Cost Explorer",
        'icon_emoji': ':aws:',
        "attachments":[
                          {
                            "fallback":"See details: <https://console.aws.amazon.com/cost-management/home?#/dashboard|Open AWS Cost Explorer>",         
                            "pretext":"See details: <https://console.aws.amazon.com/cost-management/home?#/dashboard|Open AWS Cost Explorer>",         
                            "color": color,
                            "fields":[            
                                        {               
                                          "title": service_name + " Cost",               
                                          "value": "$" + cost           
                                        }
                                      ]
                            }
                        ]
    }

    encoded_msg = json.dumps(slack_message).encode('utf-8')
    resp = http.request('POST', webhookURL, body=encoded_msg)



def get_costs(service, granularity, start, end):
    
    client = boto3.client('ce', region_name='eu-central-1')
    
    response = client.get_cost_and_usage(
        TimePeriod={
            'Start': str(start),
            'End': str(end)
        },
        Granularity=granularity,
        Filter={
            'Dimensions': {
                'Key': 'SERVICE',
                'Values': [
                    service,
                ]
            }
        },
        Metrics=[
            'BlendedCost',
            'UnblendedCost'
        ]
    )

    json_data=json.dumps(response, indent=4, sort_keys=True)
    print(json.dumps(response, indent=4, sort_keys=True))

    t=response.get("ResultsByTime")
    print(t[0].get("Total").get("UnblendedCost"))
    
    return t[0].get("Total").get("UnblendedCost").get("Amount")
    
    
    
def monthdelta(date, delta):
    m, y = (date.month+delta) % 12, date.year + ((date.month)+delta-1) // 12
    if not m: m = 12
    d = min(date.day, [31,
        29 if y%4==0 and (not y%100==0 or y%400 == 0) else 28,
        31,30,31,30,31,31,30,31,30,31][m-1])
    return date.replace(day=d,month=m, year=y)



def lambda_handler(event, context):
    SERVICES = {'Amazon Elastic Compute Cloud - Compute', 'EC2 - Other', 'Amazon Simple Storage Service', 'Amazon Relational Database Service', 'AWS Cost Explorer', 'Amazon Route 53', 'Amazon Elastic Load Balancing'}
    today = date.today()
    WEBHOOK_URL_PARAMETER = os.environ['SLACKWEBHOOK']
    
    client = boto3.client('ssm')
    response = client.get_parameter(
                    Name=WEBHOOK_URL_PARAMETER,
                    WithDecryption=True
                )
    
    WEBHOOH_URL = response.get('Parameter').get('Value')

    # Set start and end date basing on type of report    
    if event['type'] == 'DAILY':
        start = today - timedelta(days=1)
        end = today
        send_welcome_message(str(start), event['type'], WEBHOOH_URL)
        color = '#0066ff'
    elif event['type'] == 'MONTHLY':
        first_day = today.replace(day=1)
        start = monthdelta(first_day, -1)
        end = first_day - timedelta(days=1)
        send_welcome_message(str(start.strftime("%B")), event['type'], WEBHOOH_URL)
        color = '#FF0055'

    # Iterate over each service costs
    for service in SERVICES:
        service_costs = get_costs(service, event['type'], start, end)
        send_message(service, service_costs, event['type'], color, WEBHOOH_URL)
    
    return {
        'statusCode': 200,
        'body': json.dumps('Hello from Lambda!')
    }
