...
# Add following code to your regular Dockerfile

# Install jq, less and awscli
RUN apt-get update
RUN apt-get install -y jq less

RUN curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
RUN unzip awscliv2.zip
RUN ./aws/install

COPY update-route53.sh /usr/src/app
COPY entrypoint.sh /usr/src/app

# Expose required ports
EXPOSE 8125/udp
EXPOSE 8126

# Start statsd 
ENTRYPOINT [ "/usr/src/app/entrypoint.sh" ]

# Change ecntrypoint.sh with your original entrypoint code.