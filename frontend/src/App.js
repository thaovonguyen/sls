import React, { useState } from "react";
import SignIn from "./components/sign-in/sign-in.component";
import LibrarianView from "./components/librarian-view/librarian-view.component";
import UserView from "./components/user-view/user-view.component";
import SideBar from "./components/side-bar/side-bar.component";

import "./App.css";

function App() {
  const [jwtToken, setJwtToken] = useState("");
  const [role, setRole] = useState("");
  return (
    <div className="App">
      {jwtToken === "" ? (
        <SignIn setJwtToken={setJwtToken} />
      ) : (
        <div className="view">
          <div className="side-bar">
            <SideBar />
          </div>
          <div className="content">
            {role === "user" ? <UserView /> : <LibrarianView />}
          </div>
        </div>
      )}
    </div>
  );
}

export default App;
