FROM cern/cc7-base

RUN yum -y update
RUN yum -y install git xrootd-client python-pip globus-proxy-utils
RUN pip install --upgrade pip
RUN pip install git+https://github.com/sashabaranov/easywebdav.git
RUN pip install git+https://github.com/skygrid/hep-data-backends.git
RUN pip install click

ENV X509_CERT_DIR /etc/pki/tls/certs