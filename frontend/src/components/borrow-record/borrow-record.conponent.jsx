import React, { useEffect, useState } from "react";
import Popup from "../popup/popup.component";

const defaultRecord = [];

const BorrowRecord = (props) => {
  const { user } = props;
  const [records, setRecords] = useState(defaultRecord);
  const [update, setUpdate] = useState(false);
  const [noti, setNoti] = useState(false);
  useEffect(() => {
    const fetchData = async () => {
      const response = await fetch(
        `http://localhost:8080/client/borrow/${user.id}`,
        {
          method: "GET",
          headers: {
            "Content-Type": "application/json",
          },
        }
      );
      if (!response.ok) {
        // Handle authentication failure
        console.error("Get user borrow records fail!");
        return;
      }

      // Assuming your Golang API returns a JSON with user information
      const data = await response.json();
      setRecords(data);
    };
    fetchData();
  }, [update]);
  const handleClick = async (e) => {
    e.preventDefault();

    const response = await fetch(
      `http://localhost:8080/client/borrow/${user.id}`,
      {
        method: "POST",
        headers: {
          "Content-Type": "application/json",
        },
        body: JSON.stringify({
          rid: e.target.value,
        }),
      }
    );
    if (!response.ok) {
      // Handle authentication failure
      console.error("Return book fail!");
      return;
    }
    const data = await response.json();
    if (data.Valid == false) {
      setUpdate(!update);
      setNoti(true);
    } else {
      alert(data.String);
    }
  };
  return (
    <div className="d-flex align-content-center justify-content-center">
      <table
        className="table table-striped mt-5"
        style={{ width: "90%", fontSize: "0.9em" }}
      >
        <thead>
          <tr>
            <th scope="col">Mã phiếu mượn</th>
            <th scope="col">Ngày mượn</th>
            <th scope="col">Ngày trả (dự tính)</th>
            <th scope="col">Ngày trả</th>
            <th scope="col">Trạng thái</th>
            <th scope="col">Số lần gia hạn</th>
            <th scope="col">Gia hạn phiếu mượn</th>
          </tr>
        </thead>
        <tbody>
          {records.map((record) => (
            <tr>
              <td scope="row" className=" text-center">
                {record.rid}
              </td>
              <td>{record.start_date}</td>
              <td>{record.expected_return_date.String}</td>
              <td>{record.return_date.String}</td>
              <td>{record.bstatus}</td>
              <td>{record.extend_time}</td>
              <td>
                <button
                  type="button"
                  className={`btn ${
                    record.bstatus == "Đang tiến hành" && record.extend_time < 2
                      ? "btn-primary"
                      : "btn-secondary"
                  } align-items-center`}
                  style={{ height: "30px" }}
                  disabled={
                    record.bstatus != "Đang tiến hành" ||
                    record.extend_time >= 2
                  }
                  value={record.rid}
                  onClick={handleClick}
                >
                  Gia hạn
                </button>
              </td>
            </tr>
          ))}
        </tbody>
      </table>
      {noti && (
        <Popup>
          <div className=" d-flex flex-column justify-content-between h-100">
            <div className="modal-header">
              <h5 className="modal-title">Thông báo</h5>
            </div>
            <div className="modal-body m-auto p-5">
              Gia hạn phiếu mượn thành công
            </div>
            <div className="modal-footer">
              <button
                type="button"
                className="btn btn-primary"
                onClick={() => setNoti(false)}
              >
                Quay lại
              </button>
            </div>
          </div>
        </Popup>
      )}
    </div>
  );
};
export default BorrowRecord;
