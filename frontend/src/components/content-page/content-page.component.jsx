import React from "react";
import { Link, Outlet, useNavigate } from "react-router-dom";

import "./content-page.styles.css";

const ContentPage = (props) => {
  const { user, setUser } = props;
  const navigate = useNavigate();
  const handleLogout = () => {
    setUser({});
    navigate("/");
  };

  return (
    <>
      <div
        style={{ justifyContent: "flex-end" }}
        className="navbar navbar-expand-lg navbar-light bg-light border-bottom top-bar d-flex"
      >
        <button
          type="button"
          className="btn btn-warning d-flex align-items-center"
          data-toggle="button"
          aria-pressed="false"
          style={{
            height: "30px",
          }}
          onClick={handleLogout}
        >
          Đăng xuất
        </button>
        <Link to={`${user.role}/${user.id}`}>
          <img
            style={{
              height: "30px",
              width: "30px",
              marginLeft: "2vw",
            }}
            src="/yuta.png"
            alt=""
          />
        </Link>
      </div>
      <Outlet />
    </>
  );
};

export default ContentPage;
