#
# REQUIRED FILES TO BUILD THIS IMAGE
# ==================================
# 
# From http://www.oracle.com/technetwork/topics/linuxx86-64soft-092277.html
#  Download the following  file:
#    - instantclient-basic-linux.x64-12.2.0.1.0.zip
# Rename the file to instantclient_MajorVer_MinorVer.zip
#     Ex instantclient_12_2.zip
#
# HOW TO BUILD THIS IMAGE
# -----------------------
# Put all downloaded files in the same directory as this Dockerfile
# Run: 
#      $ docker build -t python-ora-mss . 
#
#

# SQL Server Command Line Tools, Oracle Instant client and Python 3.6
ARG     ARG_BASE_IMAGE=ubuntu:16.04
FROM    ${ARG_BASE_IMAGE}


# apt-get and system utilities
RUN     apt-get update && apt-get install -y \
        curl apt-transport-https debconf-utils libaio1 unzip && \
        rm -rf /var/lib/apt/lists/*

# adding custom MS repository and MSSQL Client
RUN     curl https://packages.microsoft.com/keys/microsoft.asc | apt-key add - && \
        curl https://packages.microsoft.com/config/ubuntu/16.04/prod.list > /etc/apt/sources.list.d/mssql-release.list && \
        apt-get update && ACCEPT_EULA=Y apt-get install -y msodbcsql mssql-tools && \
        apt-get update && apt-get install -y unixodbc-dev && \
        echo 'export PATH="$PATH:/opt/mssql-tools/bin"' >> ~/.bashrc && \
        /bin/bash -c "source ~/.bashrc" && \
        apt-get update && \
        apt-get -y install locales && \
        locale-gen en_US.UTF-8 && \
        update-locale LANG=en_US.UTF-8 

# adding Oracle Client
ARG     ARG_INST_CLIENT_MAJ_VER=12
ARG     ARG_INST_CLIENT_MIN_VER=2
ARG     ARG_INST_CLIENT=instantclient

ENV     INST_CLIENT_MAJ_VER=${ARG_INST_CLIENT_MAJ_VER} \
        INST_CLIENT_MIN_VER=${ARG_INST_CLIENT_MIN_VER} 
ENV     INST_CLIENT=${ARG_INST_CLIENT}_${INST_CLIENT_MAJ_VER}_${INST_CLIENT_MIN_VER}


COPY    ${INST_CLIENT}.zip ./ 

RUN     unzip ${INST_CLIENT}.zip && \
        mkdir /opt/oracle && \
        mv ${INST_CLIENT}/ /opt/oracle/ && \
        rm ${INST_CLIENT}.zip && \
        ln /opt/oracle/${INST_CLIENT}/libclntsh.so.12.1 /usr/lib/libclntsh.so && \ 
        ln /opt/oracle/${INST_CLIENT}/libocci.so.12.1 /usr/lib/libocci.so && \ 
        ln /opt/oracle/${INST_CLIENT}/libociei.so /usr/lib/libociei.so && \ 
        ln /opt/oracle/${INST_CLIENT}/libnnz12.so /usr/lib/libnnz12.so 

ENV     ORACLE_BASE=/opt/oracle/${INST_CLIENT} \
        LD_LIBRARY_PATH=/opt/oracle/${INST_CLIENT} \
        TNS_ADMIN=/opt/oracle/${INST_CLIENT} \
        ORACLE_HOME=/opt/oracle/${INST_CLIENT}


# Install Python.
RUN \
        apt-get update && \
        apt-get install -y python3 python3-dev python3-pip libssl-dev libffi-dev && \
        pip3 install --upgrade pip && \
        pip install --no-cache-dir numpy scipy pandas sympy nose python-dateutil && \
        pip install --no-cache-dir pyodbc cx_Oracle pymysql && \
        rm -rf /var/lib/apt/lists/*

ENV     APP_HOME=/app \
        APP_DATA=/app/data \
        APP_LOGS=/app/logs


VOLUME  [ "${APP_DATA}", "${APP_LOGS}"]
WORKDIR "${APP_HOME}"

CMD /bin/bash 

