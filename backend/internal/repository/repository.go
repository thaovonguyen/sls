package repository

import (
	"database/sql"

	"github.com/thaovonguyen/sls/internal/models"
)


type DatabaseRepo interface {
	Connection() *sql.DB
	GetUserAccount(user string, password string) (*models.Account, error)
	GetUserInfo(userType string, uid int) (*models.UserInfo, error)
}