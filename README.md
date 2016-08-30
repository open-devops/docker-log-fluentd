# Logging Service - Fluentd
Fluentd Docker Image for Logging Service of Open DevOps Pipeline.

- Use latest Alpine Linux
- Listen port 24224 for Fluentd forward protocol
- Store logs with tag docker.** into /fluentd/log/docker.*.log (and symlink docker.log)
- Store all other logs into /fluentd/log/data.*.log (and symlink data.log)

# docker pull
docker pull devopsopen/docker-log-fluentd

# docker run
docker run -d -p 24224:24224 -v /logdata:/fluentd/log --name fluentd devopsopen/docker-log-fluentd
