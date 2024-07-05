import React from 'react';
import { Link } from 'react-router-dom';

export const Header: React.FC = () => {
  return (
    <nav>
      <ul>
        <li><Link to="/">Login</Link></li>
        <li><Link to="/participants">Participants</Link></li>
        <li><Link to="/ranking">Ranking</Link></li>
      </ul>
    </nav>
  );
};

