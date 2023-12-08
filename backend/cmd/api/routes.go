package main

import (
	"net/http"

	"github.com/go-chi/chi/v5"
	"github.com/go-chi/chi/v5/middleware"
)

func (app *application) routes() http.Handler {
	// create a router mux
	mux := chi.NewRouter()

	mux.Use(middleware.Recoverer)
	mux.Use(app.enableCORS)
	// login
	mux.Post("/login", app.Authenticate)
	// get user info
	// mux.Get("/staff/1", app.GetStaffInfoHandler)
	mux.Route("/client",func(r chi.Router) {
		r.Get("/{uid}", app.GetClientInfoHandler)
	})
	mux.Route("/staff",func(r chi.Router) {
		r.Get("/{uid}", app.GetStaffInfoHandler)
	})
	// mux.Route("/client",func(r chi.Router) {
	// 	r.Get("/:uid", app.GetClientInfoHandler)
	// })

	return mux
}