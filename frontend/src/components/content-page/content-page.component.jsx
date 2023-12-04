import React from "react";
import { Outlet } from "react-router-dom";

import "./content-page.styles.css";

const ContentPage = () => {
  return (
    <>
      <div
        style={{ justifyContent: "flex-end" }}
        className="navbar navbar-expand-lg navbar-light bg-light border-bottom top-bar d-flex"
      >
        <img
          style={{
            height: "30px",
            width: "30px",
          }}
          src="/yuta.png"
          alt=""
        />
      </div>
      <Outlet />
    </>
  );
};

export default ContentPage;
