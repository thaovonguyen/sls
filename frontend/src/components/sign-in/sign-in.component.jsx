import React, { useState } from "react";
import "./sign-in.styles.css";

const defaultFormFields = {
  email: "",
  password: "",
};

const SignIn = (props) => {
  const { setJwtToken } = props;
  const [formFields, setFormFields] = useState(defaultFormFields);

  const handleChange = (event) => {
    const { name, value } = event.target;
    console.log(name);
    setFormFields({ ...formFields, [name]: value });
  };
  const { email, password } = formFields;
  const handleSubmit = (e) => {
    e.preventDefault();
    setJwtToken("a");
  };

  return (
    <div className="text-center sign-in">
      <form className="form-signin" onSubmit={handleSubmit}>
        <img src="./sls-icon.png" alt="literature-1" className="mb-4" />
        <h1 className="h3 mb-3 font-weight-normal">Please sign in</h1>
        <label className="sr-only">Email address</label>
        <input
          name="email"
          type="email"
          onChange={handleChange}
          value={email}
          className="form-control"
          placeholder="Email address"
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
