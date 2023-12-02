import React from "react";

import "./side-bar.styles.css";

const SideBar = () => {
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
        <h1 className="signout-btn text-center mt-3">Sign out</h1>
      </div>
    </div>

    //       <a href="#" className="nav-link link-dark">
    //         Customers
    //       </a>
  );
};

export default SideBar;
