import React, { useEffect, useState } from "react";
import { RankingListSkeleton } from "./RankingListSkeleton";
import { CountryRank } from "./CountryRank";
import { countries } from "../assets/ParticipantList";

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
  // const apiBaseUrl = import.meta.env.REACT_APP_API_BASE_URL;

  const [ranking, setRanking] = useState<Participant[]>([]);
  const [loading, setLoading] = useState(true);
  const [error, setError] = useState<string | null>(null);

  useEffect(() => {
    const fetchRanking = async () => {
      setLoading(true);
      setError(null);
      try {
        // const response = await axios.get(`${apiBaseUrl}/ranking`);
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
        <h2 className="text-9xl font-bold mb-4 text-center text-white p-8">
          Ranking
        </h2>
        <ul className="space-y-4">
          {ranking.map((participant, index) => {
            const country = countries.find((country) => {
              return country.country === participant.name;
            });
            return (
              <CountryRank
                participant={{
                  position: index,
                  ...participant,
                  code: country?.code,
                  songId: country?.songId,
                }}
              />
            );
          })}
        </ul>
      </div>
    </div>
  );
};
