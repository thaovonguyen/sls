package models

type UserInfo interface {
}

type StaffInfo struct {
	SID       int    `json:"sid"`
	FNAME     string `json:"fname"`
	LNAME     string `json:"lname"`
	SEX       string `json:"sex"`
	CIC       string `json:"cic"`
	BDATE     string `json:"bdate"`
	PHONE     string `json:"phone"`
	EMAIL     string `json:"email"`
	STARTDATE string `json:"startDate"`
	ENDDATE   string `json:"endDate"`
	BID       int    `json:"bid"`
}

type ClientInfo struct {
	UID           int    `json:"uid"`
	FNAME         string `json:"fname"`
	LNAME         string `json:"lname"`
	PAPER_TYPE    string `json:"paper_type"`
	PAPER_NUM     string `json:"paper_num"`
	PAPER_PATH    string `json:"paper_path"`
	HOME_ADDRESS  string `json:"home_address"`
	BDATE         string `json:"bdate"`
	WORKPLACE     string `json:"workplace"`
	PHONE         string `json:"phone"`
	EMAIL         string `json:"email"`
	USTATUS       string `json:"ustatus"`
	WARNING_TIME  int    `json:"warning_time"`
	REGISTER_DATE string `json:"register_date"`
}
