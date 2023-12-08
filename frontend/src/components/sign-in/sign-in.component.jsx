import React, { useState } from "react";
import "./sign-in.styles.css";
import { useNavigate } from "react-router";

const defaultFormFields = {
  text: "",
  password: "",
};

const SignIn = (props) => {
  const navigate = useNavigate();

  const { setUser } = props;
  const [formFields, setFormFields] = useState(defaultFormFields);

  const handleChange = (event) => {
    const { name, value } = event.target;
    setFormFields({ ...formFields, [name]: value });
  };
  const { text, password } = formFields;
  const handleSubmit = async (e) => {
    e.preventDefault();
    try {
      const response = await fetch("http://localhost:8080/login", {
        method: "POST",
        headers: {
          "Content-Type": "application/json",
        },
        body: JSON.stringify({
          user: formFields.text,
          password: formFields.password,
        }),
      });

      if (!response.ok) {
        // Handle authentication failure
        console.error("Authentication failed");
        return;
      }

      // Assuming your Golang API returns a JSON with user information
      const data = await response.json();

      if (data.result !== "Đăng nhập thành công") {
        alert(data.result);
      } else {
        const user = { id: data.id, role: data.type };
        setUser(user);
        navigate(`/${user.role}/${user.id}`);
      }
    } catch (error) {
      console.error("Error during authentication", error);
    }
  };

  return (
    <div className="text-center sign-in">
      <form className="form-signin" onSubmit={handleSubmit}>
        <img src="/sls-icon.png" alt="literature-1" className="mb-4" />
        <h1 className="h3 mb-3 font-weight-normal">Please sign in</h1>
        <label className="sr-only">Email address</label>
        <input
          name="text"
          type="text"
          onChange={handleChange}
          value={text}
          className="form-control"
          placeholder="Username"
          required
          autoFocus
        ></input>
        <label className="sr-only">Password</label>
        <input
          name="password"
          type="password"
          value={password}
          onChange={handleChange}
          className="form-control"
          placeholder="Password"
          required
          autoFocus
        ></input>
        <button className="btn btn-lg btn-primary btn-block" type="submit">
          Sign in
        </button>
      </form>
    </div>
  );
};

export default SignIn;
