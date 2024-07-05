import React from 'react';
import { Routes, Route } from 'react-router-dom';
import {LoginPage} from './pages/LoginPage';
import {VotingPage} from './pages/VotingPage';
import {RankingPage} from './pages/RankingPage';
import {Header} from './components/Header';


export const App: React.FC = () => {
  return (
    <div>
      <Header />
      <Routes>
        <Route path="/" element={<LoginPage />} />
        <Route path="/participants" element={<VotingPage />} />
        <Route path="/ranking" element={<RankingPage />} />
      </Routes>
    </div>
  );
};

