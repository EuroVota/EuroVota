import React, { createContext, useContext, useEffect, useState } from "react";

interface AuthContextProps {
  userId: string | null;
  username: string | null;
  login: (userId: string, username: string) => void;
  logout: () => void;
}

const AuthContext = createContext<AuthContextProps | undefined>(undefined);

export const AuthProvider: React.FC = ({ children }) => {
  const [userId, setUserId] = useState<string | null>(null);
  const [username, setUsername] = useState<string | null>(null);

  useEffect(() => {
    // Intenta recuperar userId y username del localStorage al cargar la aplicación
    const storedUserId = localStorage.getItem("userId");
    const storedUsername = localStorage.getItem("username");
    if (storedUserId && storedUsername) {
      setUserId(storedUserId);
      setUsername(storedUsername);
    }
  }, []);

  const login = (userId: string, username: string) => {
    setUserId(userId);
    setUsername(username);
    localStorage.setItem("userId", userId);
    localStorage.setItem("username", username); // Almacena userId y username en localStorage
  };

  const logout = () => {
    setUserId(null);
    setUsername(null);
    localStorage.removeItem("userId");
    localStorage.removeItem("username"); // Elimina userId y username de localStorage al cerrar sesión
  };

  return (
    <AuthContext.Provider value={{ userId, username, login, logout }}>
      {children}
    </AuthContext.Provider>
  );
};

export const useAuth = () => {
  const context = useContext(AuthContext);
  if (!context) {
    throw new Error("useAuth must be used within an AuthProvider");
  }
  return context;
};
