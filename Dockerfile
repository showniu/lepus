FROM centos:6.6

ENV LEPUS_VERSION Lepus_v3.8_Beta

COPY mariadb.repo /etc/yum.repos.d/mariadb.repo

RUN yum install -y httpd php php-mysql gcc libffi-devel python-devel openssl-devel MariaDB MariaDB-devel unzip net-snmp* && yum clean all && rm -rf /var/lib/mysql

COPY lepus /lepus

RUN cd /lepus/MySQLdb1-master/ && python setup.py build && python setup.py install && cd /lepus/pymongo-2.7/ && python setup.py install && cd /lepus/redis-2.10.3/ && python setup.py install

RUN \
cd / &&
unzip /lepus/$LEPUS_VERSION.zip && \
chmod +x /$LEPUS_VERSION/python/install.sh &&\
chmod +x /lepus/run.sh

RUN cd /$LEPUS_VERSION/python && sh install.sh

RUN cp -ap /$LEPUS_VERSION/php/* /var/www/html/.

RUN chmod +x /lepus/config.sh && sh /lepus/config.sh

CMD ["/lepus/run.sh"]
