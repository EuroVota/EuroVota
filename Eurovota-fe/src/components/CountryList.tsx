import React from "react";
import { Country } from "./Country";
import { countries } from "../assets/ParticipantList";

export const CountryList: React.FC = () => {
  return (
    <div className="flex justify-center items-center min-h-screen bg-transparent">
      <div className="max-w-5xl mx-auto h-full p-8">
        <h1 className="text-4xl font-bold text-white mb-4">
          List of Countries
        </h1>
        <ul className="divide-y divide-gray-200">
          {countries.map((participant) => (
            <li key={participant.id} className="py-4">
              <Country participant={participant} />
            </li>
          ))}
        </ul>
      </div>
    </div>
  );
};
