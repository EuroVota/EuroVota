import React from "react";
import { CountryList } from "../components/CountryList";

import "../styles/background.css";

export const VotingPage: React.FC = () => {
  return (
    <div className="voting-page">
      <div className="voting-content">
        <CountryList />
      </div>
    </div>
  );
};
