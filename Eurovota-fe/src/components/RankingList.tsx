import React, { useEffect, useState } from "react";
import axios from "axios";
import { RankingListSkeleton } from "./RankingListSkeleton";
import { CountryRank } from "./CountryRank";

interface Participant {
  id: number;
  name: string;
  votes: number;
}
const mockRanking: Participant[] = [
  { id: 1, name: "Italy", votes: 250 },
  { id: 2, name: "Spain", votes: 180 },
  { id: 3, name: "France", votes: 165 },
  { id: 4, name: "Germany", votes: 140 },
  { id: 5, name: "United Kingdom", votes: 120 },
];

export const RankingList: React.FC = () => {
  const [ranking, setRanking] = useState<Participant[]>([]);
  const [loading, setLoading] = useState(true);
  const [error, setError] = useState<string | null>(null);

  useEffect(() => {
    const fetchRanking = async () => {
      setLoading(true);
      setError(null);
      try {
        const response = await axios.get("http://localhost:5000/ranking");
        setRanking(mockRanking);
        // setRanking(response.data);
      } catch (error) {
        setError("Failed to load ranking. Please try again later.");
      } finally {
        setLoading(false);
      }
    };
    fetchRanking();
  }, []);

  if (loading) {
    return <RankingListSkeleton />;
  }

  if (error) {
    return (
      <div className="min-h-screen flex items-center justify-center bg-side-bg bg-cover bg-center text-red-500">
        {error}
      </div>
    );
  }

  return (
    <div className="min-h-screen flex items-center justify-center bg-side-bg bg-cover bg-center">
      <div className="container mx-auto">
        <h2 className="text-2xl font-bold mb-4 text-center">Ranking</h2>
        <ul className="space-y-4">
          {ranking.map((participant, index) => (
            <CountryRank participant={{ position: index, ...participant }} />
          ))}
        </ul>
      </div>
    </div>
  );
};
