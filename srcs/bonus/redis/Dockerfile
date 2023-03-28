FROM debian:buster

# Install packages:
# - redis: required, redis itself
RUN apt-get update && \
    apt-get install redis -y

# Copy setup script to local bin directory
COPY ./tools/setup.sh /usr/local/bin

# Change setup script permissions so it becomes executable
RUN chmod +x /usr/local/bin/setup.sh

# Expose port 9000 for communication with other containers
EXPOSE 6379

# Set entrypoint to be setup script
ENTRYPOINT ["setup.sh"]

# Run redis daemon with protected mode disabled*
CMD ["redis-server", "--protected-mode", "no"]

# *By default, redis enables protected mode, which prevents connections from external addresses.
# However, since Redis is running inside a container, it is necessary to allow external connections.
# In such case, --protected-mode no can be used to disable protected mode and allow external connections.
