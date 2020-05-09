import json
import os
from azure.servicebus.control_client import ServiceBusService, Message, Topic, Rule

SHARED_ACCESS_KEY_NAME = os.getenv("PUBLISHER_SAS_KEY_NAME", "TopicPublisher")
SHARED_ACCESS_KEY_VALUE = os.getenv("PUBLISHER_SAS_VALUE")
TOPIC_NAME = os.getenv("TOPIC_NAME", "example-servicebus-topic")

def send_messages():

    bus = ServiceBusService(
        service_namespace="example-servicebus-namespace",
        shared_access_key_name=SHARED_ACCESS_KEY_NAME,
        shared_access_key_value=SHARED_ACCESS_KEY_VALUE
    )

    join_message = json.dumps({
        "event_type": "join",
        "name": "宮沢 賢治",
        "date_of_birth": "1896-08-27",
        "joined_at": "2020-04-01",
        "department": "system development"
    }).encode('utf-8')

    move_message = json.dumps({
        "event_type": "move",
        "name": "宮沢 賢治",
        "department": "human resource"
    }).encode('utf-8')

    leave_message = json.dumps({
        "event_type": "leave",
        "name": "宮沢 賢治",
        "joind_at": "2020-04-01",
        "leaving_at": "2020-05-30",
    }).encode('utf-8')

    messages = [
        Message(join_message, type="application/json", custom_properties={"event_type": "join", "messageposition": 0}),
        Message(move_message, type="application/json", custom_properties={"event_type": "move", "messageposition": 0}),
        Message(leave_message, type="application/json", custom_properties={"event_type": "leave", "messageposition": 0})
    ]

    for m in messages:
        bus.send_topic_message(TOPIC_NAME, m)
        print(f"send message: {m}")

if __name__ == "__main__":
    send_messages()
