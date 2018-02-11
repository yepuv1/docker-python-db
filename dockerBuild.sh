#!/bin/bash
BASE_IMAGE=ubuntu:16.04
INST_CLIENT_MAJ_VER=12
INST_CLIENT_MIN_VER=2
INST_CLIENT=instantclient

docker build  \
             --build-arg ARG_BASE_IMAGE=${BASE_IMAGE} \
             --build-arg ARG_INST_CLIENT_MAJ_VER=${INST_CLIENT_MAJ_VER} \
             --build-arg ARG_INST_CLIENT_MIN_VER=${INST_CLIENT_MIN_VER} \
             --build-arg ARG_INST_CLIENT=${INST_CLIENT} \
             --tag python3-ora-mssql .
