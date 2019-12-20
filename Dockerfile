FROM amazonlinux:2

MAINTAINER IMSS ADS <imss-ads-staff@caltech.edu>

USER root

RUN yum -y update && \
    yum -y install \
        gcc \
        git \
        libcurl-devel \
        openldap-devel \
        openssl-devel \
        # Python 2 \
        python-devel \
        python-virtualenv \
        # Apache
        http \
        mod_ssl \
        # mod_python build support
        gcc \
        flex \
        make \
        httpd-devel \
        libffi-devel \
        openssl-devel \
    && yum -y clean all

WORKDIR /usr/local/src
RUN git clone https://github.com/grisha/mod_python
WORKDIR /usr/local/src/mod_python
RUN ./configure && \
    make && \
    make install && \
    echo 'LoadModule python_module modules/mod_python.so' > /etc/httpd/conf.modules.d/10-python.conf

CMD ["/bin/bash"]
