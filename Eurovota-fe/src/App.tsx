import React from 'react';
import { Routes, Route } from 'react-router-dom';
import {LoginPage} from './pages/LoginPage';
import {VotingPage} from './pages/VotingPage';
import {RankingPage} from './pages/RankingPage';
import {Header} from './components/Header';
import { RegisterForm } from './components/RegisterForm';
import { VerificationForm } from './components/VerificationForm';


export const App: React.FC = () => {
  return (
    <div>
      <Header />
      <Routes>
        <Route path="/" element={<LoginPage />} />
        <Route path="/participants" element={<VotingPage />} />
        <Route path="/ranking" element={<RankingPage />} />
        <Route path="/register" element={<RegisterForm />} />
        <Route path="/verify" element={<VerificationForm />} />
      </Routes>
    </div>
  );
};

