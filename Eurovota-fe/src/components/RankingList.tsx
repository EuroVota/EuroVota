import React, { useEffect, useState } from "react";
import { RankingListSkeleton } from "./RankingListSkeleton";
import { CountryRank } from "./CountryRank";
import { countries } from "../assets/ParticipantList";
import axios from "axios";
import { useAuth } from "../contexts/AuthContext";

interface Participant {
  name: string;
  votes: number;
}

export const RankingList: React.FC = () => {
  const apiBaseUrl = import.meta.env.VITE_REACT_APP_API_BASE_URL;
  const { idToken } = useAuth();

  const [ranking, setRanking] = useState<Participant[]>([]);
  const [loading, setLoading] = useState(true);
  const [error, setError] = useState<string | null>(null);

  useEffect(() => {
    const fetchRanking = async () => {
      setLoading(true);
      setError(null);
      try {
        const response = await axios.get(`${apiBaseUrl}/votes`, {
          headers: {
            Authorization: `Bearer ${idToken}`,
          },
        });
        const participants: Participant[] = response.data.map(
          (country: any) => ({
            name: country.first,
            votes: country.second,
          })
        );

        const updatedParticipants = [...participants];
        countries.forEach((country) => {
          if (!participants.some((p) => p.name === country.country)) {
            updatedParticipants.push({ name: country.country, votes: 0 });
          }
        });

        setRanking(updatedParticipants);
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
            const country = countries.find(
              (country) => country.country === participant.name
            );
            return (
              <CountryRank
                key={participant.name}
                participant={{
                  position: index + 1,
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
