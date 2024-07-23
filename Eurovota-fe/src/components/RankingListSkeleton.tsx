import React from "react";
import Skeleton from "./Skeleton";

export const RankingListSkeleton: React.FC = () => {
  return (
    <div className="flex justify-center items-center h-screen">
      <div className="space-y-4 w-96">
        {Array.from({ length: 10 }).map((_, index) => (
          <div
            key={index}
            className="flex items-center space-x-4 p-4 bg-white shadow rounded-lg"
          >
            <Skeleton className="h-4 w-6" />
            <div className="flex-1 space-y-2">
              <Skeleton className="h-4 w-3/4" />
              <Skeleton className="h-4 w-1/2" />
            </div>
          </div>
        ))}
      </div>
    </div>
  );
};
