import React, { useEffect, useState } from "react";
import Search from "../search/search.component";
import Popup from "../popup/popup.component";

const BookPage = (props) => {
  const [docs, setDocs] = useState([]);
  const [renderDocs, setRenderDocs] = useState([]);
  const [select, setSelect] = useState({});
  const [addInfo, setAddInfo] = useState({});
  const [open, setOpen] = useState(false);
  const [search, setSearch] = useState("");
  useEffect(() => {
    const fetchData = async () => {
      const response = await fetch(`http://localhost:8080/client/docs`, {
        method: "GET",
        headers: {
          "Content-Type": "application/json",
        },
      });
      if (!response.ok) {
        // Handle authentication failure
        console.error("Get documents records fail!");
        return;
      }
      const data = await response.json();
      setDocs(data);
      setRenderDocs(data);
    };
    fetchData();
  }, []);
  const onChangeHandler = async (e) => {
    console.log(e.target.value);
    if (e.target.value == "") setRenderDocs(docs);
    else setSearch(e.target.value);
    console.log(renderDocs);
  };
  const onKeyDownHandler = async (e) => {
    if (e.key === "Enter" && search != "") {
      const response = await fetch(`http://localhost:8080/client/docs/search`, {
        method: "POST",
        headers: {
          "Content-Type": "application/json",
        },
        body: JSON.stringify({
          search: search,
        }),
      });
      if (!response.ok) {
        // Handle authentication failure
        console.error("Get documents records fail!");
        return;
      }
      const data = await response.json();
      console.log([{ ...data }]);
      setRenderDocs([{ ...data }]);
    } else {
    }
  };
  return (
    <>
      <div className="d-flex flex-column align-content-center justify-content-center flex-wrap">
        <Search
          onChangeHandler={onChangeHandler}
          onKeyDownHandler={onKeyDownHandler}
        />
        <table
          className="table table-striped  table-hover"
          style={{ width: "90%", fontSize: "0.9em" }}
        >
          <thead>
            <tr>
              <th scope="col">Mã tài liệu</th>
              <th scope="col">Tên</th>
              <th scope="col">Tóm tắt</th>
              <th scope="col">Nhà xuất bản</th>
              <th scope="col">Giá bìa</th>
            </tr>
          </thead>
          <tbody>
            {renderDocs.map((record) => {
              return (
                <tr
                  onClick={async () => {
                    setSelect({ ...record });
                    setOpen(true);
                    const response = await fetch(
                      `http://localhost:8080/client/docs/${record.did}`,
                      {
                        method: "GET",
                        headers: {
                          "Content-Type": "application/json",
                        },
                      }
                    );
                    if (!response.ok) {
                      // Handle authentication failure
                      console.error("Get documents records fail!");
                      return;
                    }
                    const data = await response.json();
                    console.log(data);
                    setAddInfo({ ...data });
                  }}
                >
                  <td>{record.did}</td>
                  <td>{record.dname}</td>
                  <td>{record.abstract.substring(0, 30) + "..."}</td>
                  <td>{record.publisher}</td>
                  <td>{record.coverCost}</td>
                </tr>
              );
            })}
          </tbody>
        </table>
      </div>
      {open && (
        <Popup>
          <div className=" d-flex flex-column justify-content-between h-100">
            <div className="modal-header">
              <h5 className="modal-title">
                {addInfo.type + ": " + select.dname}
              </h5>
            </div>
            <div className="modal-body p-2">
              <div>
                {addInfo.type == "Sách"
                  ? `Tác giả: ${addInfo.author}`
                  : addInfo.type == "Tạp chí"
                  ? `Số: ${addInfo.volumn}`
                  : `Quốc gia: ${addInfo.nation}`}
              </div>
              <div>
                {addInfo.type == "Sách"
                  ? `Thể loại: ${addInfo.btype}`
                  : addInfo.type == "Tạp chí"
                  ? `Chủ đề chính: ${addInfo.highlight}`
                  : `Lĩnh vực: ${addInfo.field}`}
              </div>
              <div>{"Tóm tắt: " + select.abstract}</div>
            </div>
            <div className="modal-footer">
              <button
                type="button"
                className="btn btn-primary"
                onClick={() => {
                  setAddInfo({});
                  setSelect({});
                  setOpen(false);
                }}
              >
                Đặt trước
              </button>
              <button
                type="button"
                className="btn btn-primary"
                onClick={() => {
                  setAddInfo({});
                  setSelect({});
                  setOpen(false);
                }}
              >
                Quay lại
              </button>
            </div>
          </div>
        </Popup>
      )}
    </>
  );
};

export default BookPage;
