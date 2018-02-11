#! /bin/bash

docker run --name ora-server \
        -p 1521:1521 \
	-p 5500:5500 \
	-e ORACLE_PWD='tXwuFbn5WXo=1'\
	oracle/database:12.2.0.1-se2

