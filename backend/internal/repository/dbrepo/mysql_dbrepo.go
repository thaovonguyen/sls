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

func (m *MySQLDBRepo) GetUserAccount(clientinfo string, password string) (*models.Account, error) {
	var account models.Account
	
	stmt, err := m.DB.Prepare("CALL authorization(?, ?)")
	if err != nil {
		log.Fatal(err)
		return nil, err
	}
	defer stmt.Close()

	// Execute the stored procedure
	err = stmt.QueryRow(clientinfo, password).Scan(&account.RESULT, &account.ID, &account.TYPE)
	if err != nil {
		log.Fatal(err)
		return nil, err
	}

	return &account, nil
}

func (m *MySQLDBRepo) GetUserInfo(userType string, uid int) (*models.UserInfo, error) {
	var userinfo models.UserInfo
	stmt, err := m.DB.Prepare("CALL GetUserInformation(?, ?)")
	if err != nil {
		log.Fatal(err)
		return nil, err
	}
	defer stmt.Close()
	switch userType {
		case "staff":
			var staffinfo models.StaffInfo
			err = stmt.QueryRow("staff",uid).Scan(
				&staffinfo.SID, 
				&staffinfo.FNAME,
				&staffinfo.LNAME,
				&staffinfo.SEX,
				&staffinfo.CIC,
				&staffinfo.BDATE,
				&staffinfo.PHONE,
				&staffinfo.EMAIL,
				&staffinfo.STARTDATE,
				&staffinfo.ENDDATE,
				&staffinfo.BID,
			)
			if err != nil {
				log.Fatal(err)
				return nil, err
			}
			userinfo = staffinfo
		case "client":
			var clientinfo models.ClientInfo
			err = stmt.QueryRow("client",uid).Scan(
				&clientinfo.UID,
				&clientinfo.FNAME,
				&clientinfo.LNAME,
				&clientinfo.PAPER_TYPE,
				&clientinfo.PAPER_NUM,
				&clientinfo.PAPER_PATH,
				&clientinfo.HOME_ADDRESS,
				&clientinfo.BDATE,
				&clientinfo.WORKPLACE,
				&clientinfo.PHONE,
				&clientinfo.EMAIL,
				&clientinfo.USTATUS,
				&clientinfo.WARNING_TIME,
				&clientinfo.REGISTER_DATE,
			)
			if err != nil {
				log.Fatal(err)
				return nil, err
			}
			userinfo = clientinfo
	}
	return &userinfo, nil
}

func (m *MySQLDBRepo) GetBorrowRecord(uid int) (*[]models.BorrowModel, error) {
	var records []models.BorrowModel
	stmt,err := m.DB.Prepare("CALL GetBorrowRecord(?)")

	if err != nil {
		log.Fatal(err)
		return nil, err
	}
	defer stmt.Close()
	rows, err := stmt.Query(uid)
	
	if err != nil {
		log.Fatal(err)
		return nil, err
	}
	for rows.Next() {
		var record models.BorrowModel
		err = rows.Scan(
			&record.RID,
			&record.START_DATE,
			&record.EXPECTED_RETURN_DATE,
			&record.RETURN_DATE,
			&record.EXTEND_TIME,
			&record.BSTATUS,
			&record.SID,
			&record.UID,
			&record.DID,
			&record.PID,
			&record.DEPOSIT,
			&record.RETURN_FUND,
		)
		if err != nil {
			return nil, err
		}
		records = append(records, record)
	}
	return &records, nil
}

func (m *MySQLDBRepo) ExtendBorrow(rid string) (sql.NullString, error) {
	var result sql.NullString
	stmt,err := m.DB.Prepare("CALL ExtendBorrowTime(?)")
	if err != nil {
		log.Fatal(err)
		return sql.NullString{}, err
	}
	defer stmt.Close()
	err = stmt.QueryRow(rid).Scan(&result)
	if err != nil {
		log.Fatal(err)
		return sql.NullString{}, err
	}
	return result, nil
}