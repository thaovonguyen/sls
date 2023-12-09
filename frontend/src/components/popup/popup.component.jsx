import React from "react";
import "./popup.styles.css";

const Popup = (props) => {
  return (
    <div className="popup-background">
      <div className="popup-container">{props.children}</div>
    </div>
  );
};

export default Popup;
