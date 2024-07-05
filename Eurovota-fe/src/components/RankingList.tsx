import React, { useEffect, useState } from 'react';
import axios from 'axios';

interface Participant {
  id: number;
  name: string;
  votes: number;
}

export const RankingList: React.FC = () => {
  const [ranking, setRanking] = useState<Participant[]>([]);

  useEffect(() => {
    const fetchRanking = async () => {
      const response = await axios.get('/api/ranking');
      setRanking(response.data);
    };
    fetchRanking();
  }, []);

  return (
    <div>
      <h2>Ranking</h2>
      <ul>
        {ranking.map((participant) => (
          <li key={participant.id}>
            {participant.name}: {participant.votes} votes
          </li>
        ))}
      </ul>
    </div>
  );
};

