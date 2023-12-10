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
		r.Route("/borrow",func(r chi.Router) {
			r.Get("/{uid}", app.GetBorrowInfoHandler)
			r.Post("/{uid}", app.ExtendBorrowHandler)
		})
		r.Route("/docs", func(r chi.Router) {
			r.Get("/", app.GetDocsHandler)
			r.Get("/{did}", app.GetDocHandler)
			r.Post("/search", app.SearchDocsHandler)
		})
	})
	mux.Route("/staff",func(r chi.Router) {
		r.Get("/{uid}", app.GetStaffInfoHandler)
	})
	// mux.Route("/client",func(r chi.Router) {
	// 	r.Get("/:uid", app.GetClientInfoHandler)
	// })

	return mux
}