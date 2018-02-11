# Python with Oracle Instant Client 12.2, Microsoft SQL Server ODBC 2017 in Docker

This GitHub repository provides a Dockerfile for developing python applications that need to use Oracle, Microsoft SQL Server and MySQL as databases. 

## Required files

Download the Oracle Instant Client 12.2 Zips from OTN:

http://www.oracle.com/technetwork/topics/linuxx86-64soft-092277.html


## Building

Rename the downloaded file *instantclient-basic-linux.x64-12.2.0.1.0.zip* to *instantclient_12_2.zip*.

Place the renamed Oracle Instant Client Zip (from the previous step) in the
same directory as the `Dockerfile` and run:

```
./dockerBuild.sh -v 1.0
```
## Usage

You can run a container interactively:

```
docker run -ti --rm python3_ora_mss:1.0
```
## Volumes

The Docker image creates two volumes for ```data``` and ```logs```. The application folder structure is

```
\
|
+---app
|   |
|   +---data (docker volume)
|   |
|   +---logs (docker volume)
| 
|
+---opt (database client tools install location)

```

## ODBC Configuration 

You can query the ODBC configuration using the following command:

```
odbcinst -j
```
### Output

The output of ``odbcinst -j``

```
root@9b84d7019c0a:/# odbcinst -j
unixODBC 2.3.1
DRIVERS............: /etc/odbcinst.ini
SYSTEM DATA SOURCES: /etc/odbc.ini
FILE DATA SOURCES..: /etc/ODBCDataSources
USER DATA SOURCES..: /root/.odbc.ini
SQLULEN Size.......: 8
SQLLEN Size........: 8
SQLSETPOSIROW Size.: 8
```

The content of ``/etc/odbcinst.ini``

```
root@9b84d7019c0a:/# cat /etc/odbcinst.ini
[ODBC Driver 17 for SQL Server]
Description=Microsoft ODBC Driver 17 for SQL Server
Driver=/opt/microsoft/msodbcsql/lib64/libmsodbcsql-17.0.so.1.1
UsageCount=1
```

## Python Examples

This image can be extended to an application needs. The following examples show how to connect to different databases using Python language.

### Oracle

Create a ```tnsnames.ora``` file and point the ```TNS_ADMIN``` environment variable to it. By default the ```TNS_ADMIN``` is initialized to ```/opt/oracle/instantclient_12_2```

```
import cx_Oracle

username = 'myuserid'
password = '**********'
database_name = 'mydb'

connection = cx_Oracle.connect(username, password, database_name)
cursor = connection.cursor()
sql = "select 'Y' from dual"
cursor.execute(sql)

for row_data in cursor:
    print(row_data)
cursor.close()
```

### Microsoft SQL Server

```
import pyodbc

server = 'myserver'
database = 'mydb'
username = 'myuserid'
password = '********'
cnxn_str = 'DRIVER={ODBC Driver 17 for SQL Server};SERVER=' + server + ';DATABASE=' + database + ';UID=' + username + ';PWD=' + password

connection = pyodbc.connect(cnxn_str)
cursor = connection.cursor()
sql = "SELECT @@version;"
cursor.execute(sql)

for row_data in cursor:
    print(row_data)

cursor.close()
connection.close()
```

### MySQL

```
import pymysql.cursors

host = 'myserver'
user = 'myuserid'
password = '*******'
db = 'mydb'
charset = 'utf8mb4'
port = 3306

cnxn = pymysql.connect(host=host, port=port, user=user, db=db, charset=charset, cursorclass=pymysql.cursors.Cursor)
cursor = cnxn.cursor()
sql = "SELECT @@version;"
cursor.execute(sql)

for row_data in cursor: 
    print(row_data)
    
cursor.close()
cnxn.close()
```

## Resources

[Getting started guide for the SQL Server on Linux container](https://docs.microsoft.com/en-us/sql/linux/quickstart-install-connect-docker)

[Best practices guide](https://docs.microsoft.com/en-us/sql/linux/sql-server-linux-configure-docker)

[Oracle Database on Docker](https://github.com/oracle/docker-images/tree/master/OracleDatabase)

[Docker image contains the Oracle Instant Client](https://github.com/oracle/docker-images/tree/master/OracleInstantClient)

[Python SQL Driver](https://docs.microsoft.com/en-us/sql/connect/python/python-driver-for-sql-server)

[cx_Oracle - Python Interface for Oracle Database](https://oracle.github.io/python-cx_Oracle/)
