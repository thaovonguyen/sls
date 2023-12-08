import React, { useState } from "react";
import SignIn from "./components/sign-in/sign-in.component";

import { Link } from "react-router-dom";
import SideBar from "./components/side-bar/side-bar.component";
import { Routes, Route, Navigate } from "react-router-dom";
import "./App.css";
import ContentPage from "./components/content-page/content-page.component";
import InfoPage from "./components/info-page/info-page.component";

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
                    <Link
                      className="list-group-item list-group-item-action list-group-item-light p-3 side-bar-link"
                      to=""
                    ></Link>
                  </SideBar>
                </div>
                <div className="content">
                  <ContentPage user={user} setUser={setUser} />
                </div>
                {/* <div className="content">
                {user.role === "client" ? (
                  <UserView />
                ) : user.role === "staff" ? (
                  <LibrarianView />
                ) : (
                  <Navigate to="/login" />
                )}
              </div> */}
              </div>
            ) : (
              <Navigate to="/login" />
            )
          }
        >
          <Route
            path={`${user.role}/${user.id}`}
            index
            element={<InfoPage path={`${user.role}/${user.id}`} />}
          />
        </Route>
      </Routes>
      {/* {!login ? (
        <SignIn setLogin={setLogin} />
      ) : (
        <div className="view">
          <div className="side-bar">
            <SideBar setLogin={setLogin} />
          </div>
          <div className="content">
            {role === "user" ? <UserView /> : <LibrarianView />}
          </div>
        </div>
      )} */}
    </div>
  );
}

export default App;
