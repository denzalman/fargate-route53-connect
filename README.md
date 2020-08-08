# Fargate auto connect to Route53

Sometimes we want to make simple DNS registration for our service running on AWS Fargate. But it's not trivial task to do in automatic manner. 
Following workaround could help to release such automation. 

All code in the repository are only template and **can't** be used as-is without editing. Has to be added to original service files and changed following to service's definition.

### Dockerfile and entrypoint changes

* Add Dockerfile lines to the end of the original one and replace existed entrypoint. If in use not Debian-based image - change installation commands for relevant ones. Also check relevant **awscli** version for base image OS.

* Change the last line inside **entrypoint.sh** file with your original entrypoint code.


### Route53 registration script

[route53.sh](https://github.com/denzalman/repo/blob/branch/route53.sh) "magic" description:

* Call the Task Metadata Endpoint to get current TaskARN and Cluster ID.
* Using those, call the ECS API to get attached network interface (ENI).
* Call the EC2 API to get the details for the ENI, i.e. public IP address.
* With public IP is possible to construct an UPSERT record that after will be sent to the Route53 API using the settings provided in the ECS Task definition.

### ECS Task IAM 
To make all the above working, need to add to the task some additional access rights to be able to get the information from the APIs and to be able to update Route53.
It could be a bit stricter, depending on setup and security requirements:

```json

{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Sid": "VisualEditor0",
            "Effect": "Allow",
            "Action": [
                "ec2:DescribeNetworkInterfaces",
                "ecs:DescribeTasks"
            ],
            "Resource": "*"
        },
        {
            "Effect": "Allow",
            "Action": [
                "route53:ChangeResourceRecordSets"
            ],
            "Resource": "arn:aws:route53:::hostedzone/Z2YSP3XXXXXX" <-- Change here
        }
    ]
}
```

Last step is to configure task definition with ECS environment variables which will instruct the script about Route53 Zone ID and DNS record to create or update.

```
R53_HOST=www.example.com
R53_ZONEID=Z2YSP3XXXXXX
```