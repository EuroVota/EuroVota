import React, { useEffect, useState } from 'react';
import axios from 'axios';

interface Participant {
  id: number;
  name: string;
}

export const CountryList: React.FC = () => {
  const [participants, setParticipants] = useState<Participant[]>([]);

  useEffect(() => {
    const fetchParticipants = async () => {
      const response = await axios.get('/api/participants');
      setParticipants(response.data);
    };
    fetchParticipants();
  }, []);

  const voteForParticipant = async (participantId: number) => {
    const token = localStorage.getItem('token');
    await axios.post(`/api/vote/${participantId}`, {}, {
      headers: {
        Authorization: `Bearer ${token}`,
      },
    });
  };

  return (
    <div>
      <h2>Participants</h2>
      <ul>
        {participants.map((participant) => (
          <li key={participant.id}>
            {participant.name} <button onClick={() => voteForParticipant(participant.id)}>Vote</button>
          </li>
        ))}
      </ul>
    </div>
  );
};

