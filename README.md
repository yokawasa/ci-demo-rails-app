# ci-demo-rails-app
Rails app for CI demo

### create DB service with Azure SQL database for mysql
```
$ az group create –l <location> -n <resource group name>
$ az mysql server create -l <location> –g <resource group name> \
   -n <server name> -u <user name> -p *** \
   --sku-name B_Gen4_2 --ssl-enforcement Disabled \
   --storage-size 51200
```

### firewall configuration
```
$ az mysql server firewall-rule create --resource-group <resource group name> \
   --server <server name> --name <Firewall rule name> \
   --start-ip-address 0.0.0.0 --end-ip-address 255.255.255.255
```

### SSL Disable for shortcut some procdure. 
!!This is just for Application Test. Don't use in production!!
```
az mysql server update --resource-group <resource group name> \
   --name <server name> --ssl-enforcement Disabled
```

### MySQL server conectivity check
```
$ mysql -u kyoheim@container-demo-xxx -p -h container-demo-xxx.mysql.database.azure.com
```
### Update DB information for Rails App
```
$ git clone <this repo>
$ cd ci-demo-rails-app/
$ vim railsapp/config/database.yml
```

```
default: &default
  adapter: mysql2
  encoding: utf8
  pool: 5
  username: <DB Username>
  password: <DB Password>
  host: <MySQL server hostname>
  database: testdb
```

### Preparation for dependency rails app and DB schema
```
bundle install 
# create database
bundle exec rails db:create
# define table schema (This can be skipped here)
bundle exec rails generate scaffold article title:string text:string
# create tables
bundle exec rails db:migrate
```

### Docker Build
```
docker build -t <docker-id>/railsapp:0.0.1 .
```

### Docker run test
```
docker run -d \
   -e MYSQL_USER_NAME=<mysql-user-name> \
   -e MYSQL_USER_PASS=<mysql-user-passwd> \
   -e MYSQL_HOST=<mysql-server-name> \ 
   -p 8080:8080 -p 2222:2222 \
   <docker-id>/railsapp:0.0.1

```
