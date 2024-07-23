import React from "react";

interface Participant {
  position: number;
  name: string;
  votes: number;
  code: string | undefined;
  songId: string | undefined;
}

export const CountryRank: React.FC<{ participant: Participant }> = ({
  participant,
}) => {
  return (
    <div className="country-rank flex items-center bg-white bg-opacity-80 p-8 rounded shadow-md">
      <div className="rank-number text-6xl font-bold mr-4">
        #{participant.position}
      </div>
      <iframe
        src={`https://open.spotify.com/embed/track/${participant.songId}?utm_source=generator&theme=0`}
        allow="autoplay; clipboard-write; encrypted-media; fullscreen; picture-in-picture"
        loading="lazy"
        style={{
          borderRadius: "12px",
          width: 1180,
          background: "black",
          height: 152,
        }}
      />
      <div className="country-info flex items-center ml-4 p-4">
        <img
          src={`https://flagsapi.com/${participant.code}/flat/64.png`}
          alt={`${participant.name} flag`}
          className="h-20 w-20 rounded-lg mr-4"
        />
        <div>
          <h3 className="text-2xl font-bold">{participant.name}</h3>
          <p className="text-lg text-gray-500">{participant.votes} votes</p>
        </div>
      </div>
    </div>
  );
};
