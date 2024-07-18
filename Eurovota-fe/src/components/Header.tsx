import React from "react";
import { Link } from "react-router-dom";

export const Header: React.FC = () => {
  return (
    <nav className="bg-gray-800 p-4">
      <div className="container mx-auto flex justify-between items-center">
        <div className="text-white text-lg font-bold">Eurovision Voting</div>
        <ul className="flex space-x-4">
          <li>
            <Link className="text-white hover:text-gray-300" to="/">
              Login
            </Link>
          </li>
          <li>
            <Link className="text-white hover:text-gray-300" to="/voting">
              Voting
            </Link>
          </li>
          <li>
            <Link className="text-white hover:text-gray-300" to="/ranking">
              Ranking
            </Link>
          </li>
        </ul>
      </div>
    </nav>
  );
};
