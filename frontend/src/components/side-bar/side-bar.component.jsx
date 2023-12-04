import React from "react";

import "./side-bar.styles.css";
import { useNavigate } from "react-router";

const SideBar = (props) => {
  const navigate = useNavigate();
  const { children } = props;
  return (
    <>
      <div className="sidebar-heading border-bottom">
        <img src="/sls-icon.png" alt="" className="side-bar-logo" />
        <span className=" text-center">SLS</span>
      </div>
      <div className="list-group">{children}</div>
    </>
  );
};

export default SideBar;
