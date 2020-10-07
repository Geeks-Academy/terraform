import boto3


def setIpRecords():
    client = boto3.client('ec2')
    response = client.describe_instances()
    records = []

    for r in response['Reservations']:
        for i in r['Instances']:
            try:
                record = {}
                record['Value'] = i['PublicIpAddress']
                records.append(record)
            except:
                print("EC2 without PublicIP")

    print(records)

    return records


def upsertRoute53(records):
    client = boto3.client('route53')
    zone_id = "Z04647362L8IAEEDFHM4D"

    batch = {
        'Changes': [
            {
                'Action': 'UPSERT',
                'ResourceRecordSet': {
                    'Name': 'programmers-only.com.',
                    'Type': 'A',
                    'SetIdentifier': 'Inserted with lambda',
                    'MultiValueAnswer': True,
                    'TTL': 300,
                    'ResourceRecords': records
                }
            }
        ]
    }

    batch_www = {
        'Changes': [
            {
                'Action': 'UPSERT',
                'ResourceRecordSet': {
                    'Name': 'www.programmers-only.com.',
                    'Type': 'A',
                    'SetIdentifier': 'Inserted with lambda',
                    'MultiValueAnswer': True,
                    'TTL': 300,
                    'ResourceRecords': records
                }
            }
        ]
    }

    response = client.change_resource_record_sets(
        HostedZoneId=zone_id, ChangeBatch=batch)

    response_www = client.change_resource_record_sets(
        HostedZoneId=zone_id, ChangeBatch=batch_www)


def lambda_handler(event, context):

    records = setIpRecords()
    upsertRoute53(records)
