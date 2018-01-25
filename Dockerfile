FROM centos:latest
RUN yum update -y && yum install -y epel-release && yum install -y centos-release-openstack-pike && yum clean all
RUN yum install -y supervisor memcached openstack-swift-proxy openstack-swift-account openstack-swift-container openstack-swift-object && yum clean all

RUN swift-ring-builder /etc/swift/account.builder create 8 1 0
RUN swift-ring-builder /etc/swift/container.builder create 8 1 0
RUN swift-ring-builder /etc/swift/object.builder create 8 1 0

RUN swift-ring-builder /etc/swift/account.builder add r1z1-127.0.0.1:6202/sda_ 1
RUN swift-ring-builder /etc/swift/container.builder add r1z1-127.0.0.1:6201/sda_ 1
RUN swift-ring-builder /etc/swift/object.builder add r1z1-127.0.0.1:6200/sda_ 1

RUN swift-ring-builder /etc/swift/account.builder rebalance
RUN swift-ring-builder /etc/swift/container.builder rebalance
RUN swift-ring-builder /etc/swift/object.builder rebalance

RUN mkdir -p /srv/node/
RUN chown -R swift:swift /srv/node/

COPY config/swift/*.conf /etc/swift/
COPY config/supervisord.conf /etc/supervisord.d/swift.ini

EXPOSE 8080

RUN yum clean all

CMD ["/usr/bin/supervisord", "-n"]
