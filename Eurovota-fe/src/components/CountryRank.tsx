import React from "react";
import { countries } from "../assets/ParticipantList";

interface Participant {
  id: number;
  position: number;
  name: string;
  votes: number;
}

export const CountryRank: React.FC<Participant> = (participant) => {
  const country = countries.find((country) => {
    console.log(country, participant);
    return country.country.toLowerCase() === participant.name.toLowerCase();
  });

  if (!country) {
    return <div>Country not found for participant {participant.name}</div>;
  }

  return (
    <div className="country-rank flex items-center bg-white bg-opacity-80 p-4 rounded shadow-md">
      <div className="rank-number text-3xl font-bold mr-4">
        {participant.position}
      </div>
      <iframe
        // src={`https://open.spotify.com/embed/track/${country.songId}?utm_source=generator&theme=0`}
        width="250"
        height="152"
        allow="autoplay; clipboard-write; encrypted-media; fullscreen; picture-in-picture"
        loading="lazy"
        style={{ borderRadius: "12px" }}
      />
      <div className="country-info flex items-center ml-4">
        <img
          src={`https://flagsapi.com/${country.code}/flat/64.png`}
          alt={`${participant.name} flag`}
          className="h-16 w-16 rounded-lg mr-4"
        />
        <div>
          <h3 className="text-xl font-bold">{participant.name}</h3>
          <p className="text-gray-500">{participant.votes} votes</p>
        </div>
      </div>
    </div>
  );
};
