package main

import (
	"net/http"
)

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

	acc,err := app.DB.GetUser(requestPayload.User, requestPayload.Password)
	if err != nil{
		app.errorJSON(w, err, http.StatusUnauthorized)
		return
	}
	_ = app.writeJSON(w, http.StatusOK, acc)
}