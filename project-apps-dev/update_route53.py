import boto3


def lambda_handler(event, context):
    client = boto3.client('ec2')
    client_r53 = boto3.client('route53')
    zone_id = "Z04647362L8IAEEDFHM4D"

    response = client.describe_instances()
    Records = []

    for r in response['Reservations']:
        for i in r['Instances']:
            Record = {}
            print(i['PublicIpAddress'])
            Record['Value'] = i['PublicIpAddress']
            Records.append(Record)

    print(Records)

    batch = {
        'Changes': [
            {
                'Action': 'UPSERT',
                'ResourceRecordSet': {
                    'Name': 'test.programmers-only.com.',
                    'Type': 'A',
                    'SetIdentifier': 'Test upsert',
                    'MultiValueAnswer': True,
                    'TTL': 300,
                    'ResourceRecords': Records
                }
            }
        ]
    }

    response = client_r53.change_resource_record_sets(
        HostedZoneId=zone_id, ChangeBatch=batch)
