import React from "react";
import { Link } from "react-router-dom";
import "../styles/background.css";
import { useAuth } from "../contexts/AuthContext";

export const Header: React.FC = () => {
  const { idToken, logout } = useAuth();
  const navigate = useNavigate();

  return (
    <nav className="bg-heart p-8 sticky top-0">
      <div className="container mx-auto flex justify-between items-center">
        <div className="flex items-center justify-center">
          <h1 className="text-white text-2xl font-bold">Eurovision Voting</h1>
        </div>
        <div className="flex space-x-4">
          <Link
            to="/"
            className="text-white hover:text-gray-300 px-4 py-2 border border-white rounded-full"
          >
            Voting
          </Link>
          <Link
            to="/ranking"
            className="text-white hover:text-gray-300 px-4 py-2 border border-white rounded-full"
          >
            Ranking
          </Link>
          {!idToken ? (
            <Link
              to="/login"
              className="text-white hover:text-gray-300 px-4 py-2 border border-white rounded-full"
            >
              Login
            </Link>
          ) : (
            <button
              className="w-full py-2 px-4 bg-blue-500 text-white rounded hover:bg-blue-700"
              type="submit"
              onClick={() => {
                logout();
                navigate("/");
              }}
            >
              Logout
            </button>
          )}
        </div>
      </div>
    </nav>
  );
};
