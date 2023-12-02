# Description.

231 CO2013 - DATABASE SYSTEM

## Available Scripts

### Frontend

```bash
cd frontend
```

```bash
npm install
```

Install all the required dependencies.

```bash
npm start
```

Runs the app in the development mode.\
Open [http://localhost:3000](http://localhost:3000) to view it in your browser.

The page will reload when you make changes.\
You may also see any lint errors in the console.

### Backend

```bash
cd backend
```

To connect to the database, follow these steps:

Create a `config.go` file with this content:

```go
// config.go

package main

const (
    DBUsername = "root"    // Change to your database username
    DBPassword = "your_password"    // Change to your database password
    DBHost     = "0.0.0.0"
    DBPort     = "3306"
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
