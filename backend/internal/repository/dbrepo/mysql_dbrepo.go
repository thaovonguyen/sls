package dbrepo

import (
	"database/sql"
	"log"

	"github.com/thaovonguyen/sls/internal/models"
)

type MySQLDBRepo struct {
	DB *sql.DB
}


func (m *MySQLDBRepo) Connection() *sql.DB {
	return m.DB
}

func (m *MySQLDBRepo) GetUser(user string, password string) (*models.Account, error) {
	var account models.Account
	
	stmt, err := m.DB.Prepare("CALL authorization(?, ?)")
	if err != nil {
		log.Fatal(err)
		return nil, err
	}
	defer stmt.Close()

	// Execute the stored procedure
	err = stmt.QueryRow(user, password).Scan(&account.RESULT, &account.ID, &account.TYPE)
	if err != nil {
		log.Fatal(err)
		return nil, err
	}

	return &account, nil
}

