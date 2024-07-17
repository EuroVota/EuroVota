import React, { useEffect, useState } from 'react';
import axios from 'axios';

interface Participant {
  id: number;
  name: string;
  votes: number;
}

export const RankingList: React.FC = () => {
  const [ranking, setRanking] = useState<Participant[]>([]);
  const [loading, setLoading] = useState(true);
  const [error, setError] = useState<string | null>(null);

  useEffect(() => {
    const fetchRanking = async () => {
      setLoading(true);
      setError(null);
      try {
        const response = await axios.get('http://localhost:5000/ranking');
        setRanking(response.data);
      } catch (error) {
        setError('Failed to load ranking. Please try again later.');
      } finally {
        setLoading(false);
      }
    };
    fetchRanking();
  }, []);

  if (loading) {
    return <div className="min-h-screen flex items-center justify-center bg-side-bg bg-cover bg-center">Loading...</div>;
  }

  if (error) {
    return <div className="min-h-screen flex items-center justify-center bg-side-bg bg-cover bg-center text-red-500">{error}</div>;
  }

  return (
    <div className="min-h-screen flex items-center justify-center bg-side-bg bg-cover bg-center">
      <div className="container mx-auto">
        <h2 className="text-2xl font-bold mb-4 text-center">Ranking</h2>
        <ul className="space-y-4">
          {ranking.map((participant) => (
            <li key={participant.id} className="p-4 bg-white bg-opacity-80 shadow rounded">
              {participant.name}: {participant.votes} votes
            </li>
          ))}
        </ul>
      </div>
    </div>
  );
};

