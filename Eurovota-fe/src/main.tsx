import React from "react";
import ReactDOM from "react-dom";
import "./index.css";
import { App } from "./App";
import { BrowserRouter } from "react-router-dom";
import { AuthProvider } from "./contexts/AuthContext";

ReactDOM.render(
  <BrowserRouter>
    <div className="bg-[#040241] min-h-screen">
      <AuthProvider>
        <App />
      </AuthProvider>
    </div>
  </BrowserRouter>,
  document.getElementById("root")
);
