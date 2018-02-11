# Python with Oracle Instant Client 12.2, Microsoft SQL Server ODBC 2017 in Docker

This GitHub repository provides a Dockerfile for developing applications that need to use Oracle and Microsoft SQL Server as databases. 

## Building

### Required files

Download the Oracle Instant Client 12.2 Zips from OTN:

http://www.oracle.com/technetwork/topics/linuxx86-64soft-092277.html

Rename the file *instantclient-basic-linux.x64-12.2.0.1.0.zip* to *instantclient_12_2.zip*.

Place the renamed Oracle Instant Client Zip (from the previous step) in the
same directory as the `Dockerfile` and run:

```
./dockerBuild.sh -v 1.0
```

## Resources

[Getting started guide for the SQL Server on Linux container](https://docs.microsoft.com/en-us/sql/linux/quickstart-install-connect-docker)

[Best practices guide](https://docs.microsoft.com/en-us/sql/linux/sql-server-linux-configure-docker)

[Oracle Database on Docker](https://github.com/oracle/docker-images/tree/master/OracleDatabase)

[Docker image contains the Oracle Instant Client](https://github.com/oracle/docker-images/tree/master/OracleInstantClient)

[Python SQL Driver](https://docs.microsoft.com/en-us/sql/connect/python/python-driver-for-sql-server)

[cx_Oracle - Python Interface for Oracle Database](https://oracle.github.io/python-cx_Oracle/)

**SQL Server Command Line Tools(sqlcmd,bcp)** are also available as a Docker Image. You can now deliver SQL Server management payload using this as a base image for your CI/CD scenarios. Check out the [mssql-tools Docker Image](https://hub.docker.com/r/microsoft/mssql-tools/) to get started.


Visit the [Microsoft Docker Hub page](https://hub.docker.com/u/microsoft) for more information and additional images.



