import React from "react";

const Search = (props) => {
  const { onChangeHandler, onKeyDownHandler } = props;
  return (
    <input
      className="mt-5"
      type="search"
      onChange={onChangeHandler}
      onKeyDown={onKeyDownHandler}
      placeholder="Tìm sách"
      style={{ width: "90%", fontSize: "0.9em" }}
    />
  );
};
export default Search;
