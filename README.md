# Description.

231 CO2013 - DATABASE SYSTEM

# VERY IMPORTANT NOTE

- Before getting data from the database, make sure the `model` for that data is define in the **_"backend/internal/models"_** folder.
- Any task that needs database communication is treated as a `function` of `MySQLDBRepo struct` in the **_"backend/internal/repository/dbrepo/mysql_dbrepo.go"_** file, then the function needs adding to the `DatabaseRepo interface` in the **_"backend/internal/repository/repository.go"_**.
- `routes.go` file is for routing based on the _url_ and _HTTP methods_, each route need a _url_ string and a _handler_ for handling logic on that route (process data from or to the frontend/database).
- `handlers.go` file is where to put those handlers.

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

Create a `config.go` file in the /cmd/api folder with this content:

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

Run 3 files respectively `create_database.sql`, `procedure.sql`, `function.sql`, `trigger.sql`, `event.sql` and `insert_data.sql` in MySQL to initialize the database on localhost.

In the project directory, you can run:

Install the mysql driver.

```bash
go get -u github.com/go-sql-driver/mysql
```

Run the server

```bash
go run ./cmd/api
```
