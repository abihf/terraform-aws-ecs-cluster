from __future__ import print_function
import boto3
import json
import logging
import os
import time

logging.basicConfig()
logger = logging.getLogger()
logger.setLevel(logging.DEBUG)

# Establish boto3 session
session = boto3.session.Session()
logger.debug("Session is in region %s ", session.region_name)

ec2_client = session.client('ec2')
ecs_client = session.client('ecs')
asg_client = session.client('autoscaling')
sns_client = session.client('sns')

def handle(event, context):
    record = event['Records'][0]
    topic_arn = record['Sns']['TopicArn']
    message = json.loads(record['Sns']['Message'])
    cluster_name = os.environ.get('CLUSTER_NAME')

    instance_id = message['EC2InstanceId']
    drained = drain_instance(cluster_name, instance_id)
    if drained:
        logger.info('complete lifecycle for %s', instance_id)
        asg_client.complete_lifecycle_action(
            LifecycleHookName=message['LifecycleHookName'],
            AutoScalingGroupName=message['AutoScalingGroupName'],
            LifecycleActionResult='CONTINUE',
            InstanceId=instance_id
        )
    else:
        logger.info('Resend message to SNS')
        time.sleep(.700)
        sns_client.publish(
            TopicArn=topic_arn,
            Message=json.dumps(message),
            Subject='Publishing SNS message to invoke lambda again..'
        )
    return True


def drain_instance(cluster_name, instance_id):
    instance = get_container_instance(cluster_name, instance_id)
    if instance is not None:
        if instance['runningTasksCount'] == 0:
            return True

        container_instance = instance['containerInstanceArn']
        service_tasks = list_service_tasks(cluster_name, container_instance)
        if len(service_tasks) == 0:
            return True

        if instance['status'] != 'DRAINING':
            ecs_client.update_container_instances_state(
                cluster=cluster_name,
                containerInstances=[container_instance],
                status='DRAINING'
            )
        return False
    else: # container instance can not be found, safe to destroy?
        return True


def get_container_instance(cluster_name, instance_id):
    paginator = ecs_client.get_paginator('list_container_instances')
    for page in paginator.paginate(cluster=cluster_name):
        describe_result = ecs_client.describe_container_instances(
            cluster=cluster_name,
            containerInstances=page['containerInstanceArns']
        )
        logger.debug("describe container instances response %s", describe_result)

        for instance in describe_result['containerInstances']:
            # logger.debug("Container Instance ARN: %s and ec2 Instance ID %s",instance['containerInstanceArn'],
            if instance['ec2InstanceId'] == instance_id:
                logger.info("Container instance ID of interest : %s",instance['containerInstanceArn'])
                return instance
    return None

def list_service_tasks(cluster_name, container_instance):
    """
    list task inside container_instance that is started by a service
    """
    result = []
    paginator = ecs_client.get_paginator('list_tasks')
    args = dict(
        cluster=cluster_name,
        containerInstance=container_instance,
        desiredStatus='RUNNING'
    )
    for page in paginator.paginate(**args):
        describe_result = ecs_client.describe_tasks(cluster=cluster_name, tasks=page['taskArns'])
        for task in describe_result['tasks']:
            if 'startedBy' in task and task['startedBy'][0:7] == 'ecs-svc':
                result.append(task)
                logger.info("Found service tasks: %s", task['taskArn'])
    return result
