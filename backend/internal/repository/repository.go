package repository

import (
	"database/sql"

	"github.com/thaovonguyen/sls/internal/models"
)


type DatabaseRepo interface {
	Connection() *sql.DB
	GetUser(user string, password string) (*models.Account, error)
}