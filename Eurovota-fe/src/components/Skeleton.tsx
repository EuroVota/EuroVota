import React from "react";

export const Skeleton: React.FC<{ className?: string }> = ({ className }) => {
  return <div className={`animate-pulse bg-gray-300 ${className}`} />;
};

export default Skeleton;
