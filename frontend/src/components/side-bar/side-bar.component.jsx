import React from "react";

import "./side-bar.styles.css";
import { useNavigate } from "react-router";

const SideBar = (props) => {
  const navigate = useNavigate();
  const { setUser } = props;
  return (
    <div className="d-flex flex-column side-bar-container">
      <div className="side-bar-top">
        <h1 className="text-center mt-3 text-light">Side Bar</h1>
        <hr />
      </div>
      <div className="side-bar-middle">
        <div className="side-bar-link"></div>
      </div>
      <div className="side-bar-bottom">
        <hr />
        <h1
          className="signout-btn text-center mt-3"
          onClick={() => {
            setUser({});
            navigate("/");
          }}
        >
          Sign out
        </h1>
      </div>
    </div>
  );
};

export default SideBar;
