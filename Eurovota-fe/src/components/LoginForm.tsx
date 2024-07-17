import React, { useState } from 'react';
import axios from 'axios';
import { Link } from 'react-router-dom';

interface LoginFormProps {
  onLogin: (token: string) => void;
}

export const LoginForm: React.FC<LoginFormProps> = ({ onLogin }) => {
  const [username, setUsername] = useState('');
  const [password, setPassword] = useState('');
  const [error, setError] = useState<string | null>(null);

  const handleSubmit = async (e: React.FormEvent) => {
    e.preventDefault();
    setError(null);
    try {
      const response = await axios.post('http://localhost:5000/login', { username, password });
      onLogin(response.data.token);
    } catch (error) {
      setError('Login failed. Please check your credentials and try again.');
    }
  };

  return (
    <div className="min-h-screen flex items-center justify-center bg-side-bg bg-cover bg-center">
      <form className="w-full max-w-sm p-8 bg-white bg-opacity-80 shadow-md rounded" onSubmit={handleSubmit}>
        {error && <div className="mb-4 text-red-500">{error}</div>}
        <div className="mb-4">
          <label className="block text-gray-700" htmlFor="username">Phone Number:</label>
          <input
            className="w-full px-3 py-2 border rounded"
            id="username"
            type="text"
            value={username}
            onChange={(e) => setUsername(e.target.value)}
          />
        </div>
        <div className="mb-4">
          <label className="block text-gray-700" htmlFor="password">Password:</label>
          <input
            className="w-full px-3 py-2 border rounded"
            id="password"
            type="password"
            value={password}
            onChange={(e) => setPassword(e.target.value)}
          />
        </div>
        <button className="w-full py-2 px-4 bg-blue-500 text-white rounded hover:bg-blue-700" type="submit">Login</button>
        <div className="mt-4 text-center">
          <Link to="/register" className="text-blue-500 hover:underline">Don't have an account? Register</Link>
        </div>
      </form>
    </div>
  );
};

