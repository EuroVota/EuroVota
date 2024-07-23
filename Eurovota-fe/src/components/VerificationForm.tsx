import React, { useState } from "react";
import { useLocation, useNavigate } from "react-router-dom";
import axios from "axios";
import { useAuth } from "../contexts/AuthContext";

export const VerificationForm: React.FC = () => {
  const [code, setCode] = useState("");
  const [error, setError] = useState<string | null>(null);
  const location = useLocation();
  const navigate = useNavigate();
  const { login } = useAuth();
  const apiBaseUrl = import.meta.env.VITE_REACT_APP_API_BASE_URL;

  const phone = location.state?.phone;
  console.log(phone);

  const handleSubmit = async (e: React.FormEvent) => {
    e.preventDefault();
    setError(null);
    try {
      const response = await axios.patch(`${apiBaseUrl}/users/validate`, {
        phone,
        code,
      });

      const { userId } = response.data;

      login(userId, phone);

      navigate("/");
    } catch (error) {
      setError("Verification failed. Please try again.");
    }
  };

  -"export NODE_OPTIONS=--openssl-legacy-provider";

  return (
    <div className="min-h-screen flex items-center justify-center bg-side-bg bg-cover bg-center">
      <form
        className="w-full max-w-sm p-8 bg-white bg-opacity-80 shadow-md rounded"
        onSubmit={handleSubmit}
      >
        {error && <div className="mb-4 text-red-500">{error}</div>}
        <div className="mb-4">
          <label className="block text-gray-700" htmlFor="code">
            Verification Code:
          </label>
          <input
            className="w-full px-3 py-2 border rounded"
            id="code"
            type="text"
            value={code}
            onChange={(e) => setCode(e.target.value)}
          />
        </div>
        <button
          className="w-full py-2 px-4 bg-blue-500 text-white rounded hover:bg-blue-700"
          type="submit"
        >
          Verify
        </button>
      </form>
    </div>
  );
};
