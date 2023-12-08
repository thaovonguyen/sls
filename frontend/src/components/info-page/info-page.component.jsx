import React, { useEffect, useState } from "react";

const InfoPage = (props) => {
  const { path } = props;
  const [info, setInfo] = useState({});
  useEffect(() => {
    const fetchData = async () => {
      const response = await fetch(`http://localhost:8080/${path}`, {
        method: "GET",
        headers: {
          "Content-Type": "application/json",
        },
      });
      if (!response.ok) {
        // Handle authentication failure
        console.error("Get user infomation fail!");
        return;
      }

      // Assuming your Golang API returns a JSON with user information
      const data = await response.json();
      console.log(data);
      setInfo(data);
    };
    fetchData();
  }, []);
  return (
    <div className="info--page d-flex flex-column">
      <div className="img-container d-flex flex flex-column justify-content-center align-content-center m-1 flex-wrap">
        <img
          src="https://cdn.pixabay.com/photo/2016/08/08/09/17/avatar-1577909_1280.png"
          alt="Admin"
          className="rounded-circle align-content-center m-3"
          width="100"
        />
        {info.bid ? (
          <h3 className=" align-content-center">Nhân viên</h3>
        ) : (
          <h3>Người dùng</h3>
        )}
      </div>
      <div className="card m-3">
        <div className="card-body">
          <div className="row flex-row">
            <div className="col-sm-3">
              <h6 className="mb-0">Họ và tên:</h6>
            </div>
            <div className="col-sm-9 text-secondary">
              {info.lname + " " + info.fname}
            </div>
          </div>
          <hr />
          <div className="row flex-row">
            <div className="col-sm-3">
              <h6 className="mb-0">Số điện thoại:</h6>
            </div>
            <div className="col-sm-9 text-secondary">{info.phone}</div>
          </div>
          <hr />
          <div className="row flex-row">
            <div className="col-sm-3">
              <h6 className="mb-0">Email:</h6>
            </div>
            <div className="col-sm-9 text-secondary">{info.email}</div>
          </div>
          <hr />
          <div className="row flex-row">
            <div className="col-sm-3">
              <h6 className="mb-0">Ngày sinh:</h6>
            </div>
            <div className="col-sm-9 text-secondary">{info.bdate}</div>
          </div>
          <hr />
          {info.bid ? (
            <div className="row flex-row">
              <div className="col-sm-3">
                <h6 className="mb-0">Chi nhánh số:</h6>
              </div>
              <div className="col-sm-9 text-secondary">{info.bid}</div>
            </div>
          ) : (
            <>
              <div className="row flex-row">
                <div className="col-sm-3">
                  <h6 className="mb-0">Địa chỉ:</h6>
                </div>
                <div className="col-sm-9 text-secondary">
                  {info.home_address}
                </div>
              </div>
              <hr />
              <div className="row flex-row">
                <div className="col-sm-3">
                  <h6 className="mb-0">Số lần cảnh cáo:</h6>
                </div>
                <div className="col-sm-9 text-secondary">
                  {info.warning_time}
                </div>
              </div>
            </>
          )}
        </div>
      </div>
    </div>
  );
};

export default InfoPage;
