FROM debian:buster

# Pass FTP server's user and password as arguments so Dockerfile can use them
ARG FTP_USER
ARG FTP_PASS

# Install packages:
# - vsftpd: required, vsftpd (FTP server client of my choice) itself
RUN apt-get update && \
    apt-get install -y vsftpd

# Creates chroot jail directory
# This is used for safety measures, so any authenticated users will only be allowed inside their home directories
# Or, in this case, the chroot jail directory specified below
RUN mkdir -p /var/run/vsftpd/empty

# Create FTP user and change its password to the one present in the env file
RUN adduser $FTP_USER --disabled-password && \
    echo "$FTP_USER:$FTP_PASS" | chpasswd

# Add created user to the vsftpd userlist, so the FTP client can be recognized when trying to login
RUN echo $FTP_USER > /etc/vsftpd.userlist

# Copy the vsftpd configuration file to vsftpd's default configuration directory
COPY ./conf/vsftpd.conf /etc

# Expose port 21 for communication with FTP clients and other containers
EXPOSE 21

# Run vsftpd using /etc/vsftpd.conf as configuration file
ENTRYPOINT ["vsftpd", "/etc/vsftpd.conf"]
