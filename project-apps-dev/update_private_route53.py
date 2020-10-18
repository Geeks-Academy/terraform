import boto3
import os

HOSTED_ZONE_ID = os.getenv('HOSTED_ZONE_ID')


def ifExists(serviceName):
    client = boto3.client('route53')
    ifExists = False

    response = client.list_resource_record_sets(HostedZoneId=HOSTED_ZONE_ID)

    for record in response['ResourceRecordSets']:
        if record['Type'] == "A":
            if record['Name'] == serviceName + '.programmers.only.':
                ifExists = True

    return ifExists


def addRecord(serviceName, ip):
    client = boto3.client('route53')
    record = {}
    records = []

    record['Value'] = ip
    records.append(record)

    name = serviceName + '.programmers.only.'

    batch = {
        'Changes': [
            {
                'Action': 'UPSERT',
                'ResourceRecordSet': {
                    'Name': name,
                    'Type': 'A',
                    'SetIdentifier': 'Inserted with lambda ' + serviceName + '-' + ip,
                    'MultiValueAnswer': True,
                    'TTL': 300,
                    'ResourceRecords': records
                }
            }
        ]
    }

    response = client.change_resource_record_sets(
        HostedZoneId=HOSTED_ZONE_ID, ChangeBatch=batch)

    return response


def deleteRecord(serviceName, ip):
    client = boto3.client('route53')

    record = {}
    records = []

    record['Value'] = ip
    records.append(record)

    name = serviceName + '.programmers.only.'

    batch = {
        'Changes': [
            {
                'Action': 'DELETE',
                'ResourceRecordSet': {
                    'Name': name,
                    'Type': 'A',
                    'SetIdentifier': 'Inserted with lambda ' + serviceName + '-' + ip,
                    'MultiValueAnswer': True,
                    'TTL': 300,
                    'ResourceRecords': records
                }
            }
        ]
    }

    response = client.change_resource_record_sets(
        HostedZoneId=HOSTED_ZONE_ID, ChangeBatch=batch)

    return response


def lambda_handler(event, context):
    message = event['Records'][0]['Sns']['Message']
    messageSet = message.split()
    response = "Nothing happened"

    if messageSet[0] == "create":
        response = addRecord(messageSet[1], messageSet[2])
    elif messageSet[0] == 'delete':
        response = deleteRecord(messageSet[1], messageSet[2])

    print(response)
