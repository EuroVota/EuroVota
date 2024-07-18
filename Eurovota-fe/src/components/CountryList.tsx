import React from "react";
import { Country } from "./Country";
import { countries } from "../assets/ParticipantList";

export const CountryList: React.FC = () => {
  return (
    <div className="flex justify-center items-center min-h-screen bg-gray-100">
      <div className="max-w-5xl mx-auto p-8">
        <h1 className="text-2xl font-bold mb-4">List of Countries</h1>
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
