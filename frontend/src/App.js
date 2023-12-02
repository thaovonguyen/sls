import React, { useState } from "react";
import SignIn from "./components/sign-in/sign-in.component";
import LibrarianView from "./components/librarian-view/librarian-view.component";
import UserView from "./components/user-view/user-view.component";
import SideBar from "./components/side-bar/side-bar.component";
import { Routes, Route, useNavigate, Navigate } from "react-router-dom";
import "./App.css";

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
            <div className="view">
              <div className="side-bar">
                <SideBar setUser={setUser} />
              </div>
              <div className="content">
                {user.role === "client" ? (
                  <UserView />
                ) : user.role === "staff" ? (
                  <LibrarianView />
                ) : (
                  <Navigate to="/login" />
                )}
              </div>
            </div>
          }
        />
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
