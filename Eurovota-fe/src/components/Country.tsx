interface CountryProps {
  participant: {
    id: number;
    country: string;
    singer: string;
    code: string;
  };
}

export const Country: React.FC<CountryProps> = ({ participant }) => {
  const handleVote = (participantId: number) => {
    console.log(`Voted for participant with id ${participantId}`);
  };

  return (
    <div className="flex items-center justify-between border-b border-gray-200 py-4">
      <div className="flex-shrink-0 h-16 w-16 rounded-lg overflow-hidden">
        <img
          src={`https://flagsapi.com/${participant.code}/flat/64.png`}
          alt={`${participant.country} flag`}
          className="h-full w-full object-cover"
        />
      </div>
      <div>
        <h3 className="text-lg font-semibold">{participant.country}</h3>
        <p className="text-sm text-gray-600">{participant.singer}</p>
      </div>
      <button
        onClick={() => handleVote(participant.id)}
        className="px-4 py-2 bg-blue-500 text-white rounded-md hover:bg-blue-600 focus:outline-none"
      >
        Vote
      </button>
    </div>
  );
};
