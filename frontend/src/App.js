import React, { useState } from "react";
import SignIn from "./components/sign-in/sign-in.component";

import { Link } from "react-router-dom";
import SideBar from "./components/side-bar/side-bar.component";
import { Routes, Route, Navigate } from "react-router-dom";
import "./App.css";
import ContentPage from "./components/content-page/content-page.component";
import InfoPage from "./components/info-page/info-page.component";
import BorrowRecord from "./components/borrow-record/borrow-record.conponent";
import BookPage from "./components/book-page/book-page.component";

function App() {
  // const [login, setLogin] = useState(false);
  const [user, setUser] = useState({});

  return (
    <div className="App">
      <Routes>
        <Route path="/login" element={<SignIn setUser={setUser} />} />
        <Route
          path="/"
          element={
            user.id ? (
              <div className="view">
                <div className="side-bar border-end" id="sidebar-wrapper">
                  <SideBar setUser={setUser}>
                    {user.role == "client" ? (
                      <>
                        <Link
                          className="list-group-item list-group-item-action list-group-item-light p-3 side-bar-link"
                          to="/client/docs"
                        >
                          Mượn sách
                        </Link>
                        <Link
                          className="list-group-item list-group-item-action list-group-item-light p-3 side-bar-link"
                          to={`/client/borrow/${user.id}`}
                        >
                          Phiếu mượn
                        </Link>
                      </>
                    ) : (
                      ""
                    )}
                  </SideBar>
                </div>
                <div className="content">
                  <ContentPage user={user} setUser={setUser} />
                </div>
              </div>
            ) : (
              <Navigate to="/login" />
            )
          }
        >
          <Route
            path={`${user.role}/${user.id}`}
            index={true}
            element={<InfoPage path={`${user.role}/${user.id}`} />}
          />
          <Route
            path={`client/borrow/${user.id}`}
            element={<BorrowRecord user={user} />}
          />
          <Route path={`client/docs`} element={<BookPage />} />
        </Route>
      </Routes>
    </div>
  );
}

export default App;
