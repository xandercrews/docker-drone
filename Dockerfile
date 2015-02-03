FROM centos:centos7
MAINTAINER no one

# Install real systemd
ENV container docker

RUN yum -y swap -- remove fakesystemd -- install systemd systemd-libs; \ 
    yum -y update; \ 
    yum clean all; \
    (cd /lib/systemd/system/sysinit.target.wants/; for i in *; do [ $i == systemd-tmpfiles-setup.service ] || rm -f $i; done); \
    rm -f /lib/systemd/system/multi-user.target.wants/*;\
    rm -f /etc/systemd/system/*.wants/*;\
    rm -f /lib/systemd/system/local-fs.target.wants/*; \
    rm -f /lib/systemd/system/sockets.target.wants/*udev*; \
    rm -f /lib/systemd/system/sockets.target.wants/*initctl*; \
    rm -f /lib/systemd/system/basic.target.wants/*;\
    rm -f /lib/systemd/system/anaconda.target.wants/*;

VOLUME [ "/sys/fs/cgroup" ]

# Install Drone
RUN rpm -ivh http://downloads.drone.io/master/drone.rpm && \ 
    mv /etc/drone/drone.toml{,.sample}

RUN systemctl enable drone

# Install start wrapper deps
RUN rpm -iUvh http://yum.postgresql.org/9.3/redhat/rhel-7-x86_64/pgdg-centos93-9.3-1.noarch.rpm && \
    yum -y update && \ 
    yum -y install --disablerepo=* --enablerepo=pgdg93 postgresql93 && \
    yum -y install perl && \
    yum clean all

# Install start wrapper
ADD start.sh /bin/
RUN chmod ug+rx /bin/start.sh

CMD [ "/bin/start.sh" ]
