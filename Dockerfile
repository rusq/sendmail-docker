# based on http://www.tothenew.com/blog/setting-up-sendmail-inside-your-docker-container/

# centos 6 provides init.d system, that's what we're after.
FROM centos:6
 
LABEL MAINTAINER='Rustam G <https://github.com/rusq>'

RUN yum -y update \
    && yum -y install sendmail rsyslog

RUN yum install -y m4 sendmail-cf

# fixing sendmail to listen on all interfaces
RUN sed -i~ 's/^DAEMON_OPTIONS/dnl DAEMON_OPTIONS/g' /etc/mail/sendmail.mc \
    && m4 /etc/mail/sendmail.mc > /etc/sendmail.cf

ADD entrypoint.sh /

EXPOSE 25

ENTRYPOINT ["/entrypoint.sh"]
CMD []
