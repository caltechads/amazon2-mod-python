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
        patch \
        flex \
        make \
        httpd-devel \
        libffi-devel \
        openssl-devel \
    && yum -y clean all

WORKDIR /usr/local/src
RUN git clone https://github.com/grisha/mod_python
WORKDIR /usr/local/src/mod_python
COPY patches/patch-Py_Initialize.txt /tmp
RUN LIBS="-lpython2.7" ./configure && \
    # configure gets the libpython2.7.so link argument wrong, so fix it
    sed -i.bak 's/libpython2.7.so/-lpython2.7/g' /usr/local/src/mod_python/src/Makefile && \
    patch -p1 < /tmp/patch-Py_Initialize.txt && \
    LIBS="-lpython2.7" make && \
    make install && \
    echo 'LoadModule python_module modules/mod_python.so' > /etc/httpd/conf.modules.d/10-python.conf

CMD ["/bin/bash"]
