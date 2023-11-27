# Description.

231 CO2013 - DATABASE SYSTEM

## Available Scripts

To connect to the database, follow these steps:

Create a `config.go` file with this content:

```go
// config.go

package main

const (
    DBUsername = "root"
    DBPassword = "your_password"
    DBHost     = "0.0.0.0"
    DBPort     = "3306"
    DBName     = "sls_database"
)
```

Run 3 files respectively `create_database.sql`, `insert_data.sql`, `procedure.sql` in MySQL to initialize the database on localhost.

In the project directory, you can run:

Install the mysql driver.

```bash
go get -u github.com/go-sql-driver/mysql
```

Compile the code.

```bash
go build
```

Runs the app in the development mode.

```bash
./sls
```
Open http://localhost:8080 to view it in your browser.
