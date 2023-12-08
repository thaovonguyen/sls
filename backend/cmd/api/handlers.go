package main

import (
	"fmt"
	"net/http"
	"strconv"

	"github.com/go-chi/chi/v5"
)

// login
func (app *application) Authenticate(w http.ResponseWriter, r *http.Request) {
	var requestPayload struct {
		User string `json:"user"`
		Password string `json:"password"`
	}
	err := app.readJSON(w, r, &requestPayload)
	if err != nil {
		app.errorJSON(w, err, http.StatusBadRequest)
		return
	}

	acc,err := app.DB.GetUserAccount(requestPayload.User, requestPayload.Password)
	if err != nil{
		app.errorJSON(w, err, http.StatusUnauthorized)
		return
	}
	_ = app.writeJSON(w, http.StatusOK, acc)
}

// get staff info
func (app *application) GetStaffInfoHandler(w http.ResponseWriter, r *http.Request){
	sid, err := strconv.Atoi(chi.URLParam(r,"uid"))
	if err != nil {
		app.errorJSON(w, err, http.StatusBadRequest)
		return
	}
	userInfo, err := app.DB.GetUserInfo("staff", sid)
	if err != nil {
		app.errorJSON(w, err, http.StatusUnauthorized)
		return 
	}
	
	_ = app.writeJSON(w, http.StatusOK, userInfo)
}
// get client info
func (app *application) GetClientInfoHandler(w http.ResponseWriter, r *http.Request){
	uid, err := strconv.Atoi(chi.URLParam(r,"uid"))
	
	if err != nil {
		app.errorJSON(w, err, http.StatusBadRequest)
		return
	}
	userInfo, err := app.DB.GetUserInfo("client", uid)
	if err != nil {
		app.errorJSON(w, err, http.StatusUnauthorized)
		return 
	}
	_ = app.writeJSON(w, http.StatusOK, userInfo)
}

func (app *application) GetBorrowInfoHandler(w http.ResponseWriter, r *http.Request) {
	uid, err := strconv.Atoi(chi.URLParam(r,"uid"))
	
	if err != nil {
		app.errorJSON(w, err, http.StatusBadRequest)
		return
	}
	borrowInfo, err := app.DB.GetBorrowRecord(uid)
	if err != nil {
		app.errorJSON(w, err, http.StatusUnauthorized)
		return
	}
	_ = app.writeJSON(w, http.StatusOK, borrowInfo)
}

func (app *application) ExtendBorrowHandler(w http.ResponseWriter, r *http.Request) {
	var requestPayload struct {
		Rid string `json:"rid"`
	}
	fmt.Println(r.Body)
	err := app.readJSON(w, r, &requestPayload)
	if err != nil {
		fmt.Println("cant read json")
		app.errorJSON(w, err, http.StatusBadRequest)
		return
	}

	if err != nil {
		app.errorJSON(w, err, http.StatusBadRequest)
		return
	}
	result, err := app.DB.ExtendBorrow(requestPayload.Rid)
	if err != nil {
		app.errorJSON(w, err, http.StatusUnauthorized)
		return
	}
	_ = app.writeJSON(w, http.StatusOK, result)
}