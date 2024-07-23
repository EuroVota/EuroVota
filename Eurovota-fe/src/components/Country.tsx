import axios from "axios";
import React from "react";

interface CountryProps {
  participant: {
    id: number;
    country: string;
    code: string;
    songId: string;
  };
}

export const Country: React.FC<CountryProps> = ({ participant }) => {
  const apiBaseUrl = import.meta.env.VITE_REACT_APP_API_BASE_URL;

  const handleVote = async (country: string) => {
    try {
      const response = await axios.post(`${apiBaseUrl}/votes`, {
        country,
        votes: 10,
      });
      console.log("Vote submitted successfully:", response.data);
    } catch (error) {
      console.error("Error submitting vote:", error);
    }
  };

  return (
    <div className={`bg-[#040241] text-white p-4 rounded-lg`}>
      <div className="flex items-center justify-between">
        <div className="flex-shrink-0 h-16 w-16 rounded-lg overflow-hidden">
          <img
            src={`https://flagsapi.com/${participant.code}/flat/64.png`}
            alt={`${participant.country} flag`}
            className="h-full w-full object-cover"
          />
        </div>
        <div className="flex-grow ml-4">
          <h1 className="text-4xl font-bold mb-4">{participant.country}</h1>
        </div>
        <button
          onClick={() => handleVote(participant.country)}
          className="px-4 py-2 bg-blue-500 text-white rounded-md hover:bg-blue-600 focus:outline-none"
        >
          Vote
        </button>
      </div>
      <div className="bg-gray-800 mt-4 rounded-lg overflow-hidden">
        <iframe
          title={`${participant.country} Spotify Song`}
          // src={`https://open.spotify.com/embed/track/${participant.songId}?utm_source=generator`}
          width="100%"
          height="352"
          frameBorder="0"
          allow="autoplay; clipboard-write; encrypted-media; fullscreen; picture-in-picture"
          allowFullScreen
          loading="lazy"
          style={{ borderRadius: "12px" }}
        ></iframe>
      </div>
    </div>
  );
};
