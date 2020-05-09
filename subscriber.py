import json
import os
import sys
import time

from azure.servicebus.control_client import ServiceBusService, Message, Topic, Rule

SHARED_ACCESS_KEY_NAME = os.getenv("SUBSCRIBER_SAS_KEY_NAME", "Subscriber")
SHARED_ACCESS_KEY_VALUE = os.getenv("SUBSCRIBER_SAS_VALUE")
TOPIC_NAME = os.getenv("TOPIC_NAME", "example-servicebus-topic")

def receive_messages(subscription_number):

    bus = ServiceBusService(
        service_namespace="example-servicebus-namespace",
        shared_access_key_name=SHARED_ACCESS_KEY_NAME,
        shared_access_key_value=SHARED_ACCESS_KEY_VALUE
    )

    subscription_name = f"example{subscription_number}-sevicebus-subscription"

    while True:
        print(f"receive message from {subscription_name}.")
        message = bus.receive_subscription_message(
            TOPIC_NAME,
            subscription_name,
            peek_lock=True
        )

        if message is not None:
            print(message.body)
            message.delete()
        
        time.sleep(5.0)

if __name__ == "__main__":
    args = sys.argv
    if len(args) != 2:
        print("usage: python subscriber.py <subscription number>")
        exit(1)

    receive_messages(args[1])
