package models

import "database/sql"

type BorrowModel struct {
	RID                  int    `json:"rid"`
	START_DATE           string `json:"start_date"`
	EXPECTED_RETURN_DATE sql.NullString `json:"expected_return_date"`
	RETURN_DATE          sql.NullString `json:"return_date"`
	EXTEND_TIME          int    `json:"extend_time"`
	BSTATUS              string `json:"bstatus"`
	SID                  int    `json:"sid"`
	UID                  int    `json:"uid"`
	DID                  int    `json:"did"`
	PID                  int    `json:"pid"`
	DEPOSIT              int    `json:"deposit"`
	RETURN_FUND          int    `json:"return_fund"`
}