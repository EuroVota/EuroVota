import React, { useState } from "react";
import { useNavigate } from "react-router-dom";
import axios from "axios";

export const RegisterForm: React.FC = () => {
  const [phone, setPhone] = useState("");
  const [password, setPassword] = useState("");
  const [error, setError] = useState<string | null>(null);
  const navigate = useNavigate();

  const handleSubmit = async (e: React.FormEvent) => {
    e.preventDefault();
    setError(null);

    if (!validatePassword(password)) {
      setError(
        "Password must be at least 8 characters long and contain at least one uppercase letter, one lowercase letter, and one special character."
      );
      return;
    }

    try {
      await axios.post(
        "https://tekogg2e2a.execute-api.us-east-1.amazonaws.com/eurovota-test/eurovota-api/users  ",
        { phone, password }
      );
      navigate("/verify", { state: { phone } });
    } catch (error: any) {
      if (axios.isAxiosError(error) && error.response?.status === 409) {
        navigate("/verify", { state: { phone } });
      } else {
        setError("Registration failed. Please try again.");
      }
    }
  };

  const validatePassword = (password: string): boolean => {
    const regex =
      /^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[@$!%*?&])[A-Za-z\d@$!%*?&]{8,}$/;
    return regex.test(password);
  };

  return (
    <div className="min-h-screen flex items-center justify-center bg-side-bg bg-cover bg-center">
      <form
        className="w-full max-w-sm p-8 bg-white bg-opacity-80 shadow-md rounded"
        onSubmit={handleSubmit}
      >
        {error && <div className="mb-4 text-red-500">{error}</div>}
        <div className="mb-4">
          <label className="block text-gray-700" htmlFor="phone">
            Phone Number:
          </label>
          <input
            className="w-full px-3 py-2 border rounded"
            id="phone"
            type="text"
            value={phone}
            onChange={(e) => setPhone(e.target.value)}
          />
        </div>
        <div className="mb-4">
          <label className="block text-gray-700" htmlFor="password">
            Password:
          </label>
          <input
            className="w-full px-3 py-2 border rounded"
            id="password"
            type="password"
            value={password}
            onChange={(e) => setPassword(e.target.value)}
          />
        </div>
        <button
          className="w-full py-2 px-4 bg-blue-500 text-white rounded hover:bg-blue-700"
          type="submit"
        >
          Register
        </button>
      </form>
    </div>
  );
};
