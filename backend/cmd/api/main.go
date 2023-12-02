package main

import (
	"fmt"
	"log"
	"net/http"

	_ "github.com/go-sql-driver/mysql"
	"github.com/thaovonguyen/sls/internal/repository"
	"github.com/thaovonguyen/sls/internal/repository/dbrepo"
)
 
const port = 8080

type application struct {
    DBInfo string
    DB repository.DatabaseRepo
}


func main() {
    var app application
    connectionString := fmt.Sprintf("%s:%s@tcp(%s:%s)/sls_database", DBUsername, DBPassword, DBHost, DBPort)
    app.DBInfo = connectionString
    // create a database object which can be used
    // to connect with database.
    conn, err := app.connectToDB()
    if err != nil {
        panic(err)
    }
    app.DB = &dbrepo.MySQLDBRepo{DB: conn}
    defer app.DB.Connection().Close()

    log.Println("Starting application on port", port)
    err = http.ListenAndServe(fmt.Sprintf(":%d", port), app.routes())
	if err != nil {
		log.Fatal(err)
	}
}