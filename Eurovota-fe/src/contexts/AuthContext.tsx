import React, {
  createContext,
  useContext,
  useEffect,
  useState,
  ReactNode,
} from "react";

interface AuthContextProps {
  idToken: string | null;
  username: string | null;
  login: (userId: string, username: string) => void;
  logout: () => void;
}

const AuthContext = createContext<AuthContextProps | undefined>(undefined);

export const AuthProvider: React.FC<{ children: ReactNode }> = ({
  children,
}) => {
  const [idToken, setIdToken] = useState<string | null>(null);
  const [username, setUsername] = useState<string | null>(null);

  useEffect(() => {
    const storedUserId = localStorage.getItem("idToken");
    const storedUsername = localStorage.getItem("username");
    if (storedUserId && storedUsername) {
      setIdToken(storedUserId);
      setUsername(storedUsername);
    }
  }, []);

  const login = (idToken: string, username: string) => {
    setIdToken(idToken);
    setUsername(username);
    localStorage.setItem("idToken", idToken);
    localStorage.setItem("username", username);
  };

  const logout = () => {
    setIdToken(null);
    setUsername(null);
    localStorage.removeItem("userId");
    localStorage.removeItem("username");
  };

  return (
    <AuthContext.Provider value={{ idToken: idToken, username, login, logout }}>
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
