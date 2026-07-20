import React from 'react';

export function ModuleCardSkeleton() {
  return (
    <div className="bg-bg-surface border border-border p-6 rounded-lg relative overflow-hidden h-48 flex flex-col justify-between">
      <div className="space-y-3">
        {/* Title */}
        <div className="h-6 w-3/4 skeleton rounded" />
        {/* Level badge */}
        <div className="h-4 w-1/4 skeleton rounded" />
      </div>
      {/* Progress ring/stats placeholder */}
      <div className="flex items-center gap-4">
        <div className="h-10 w-10 skeleton rounded-full" />
        <div className="h-4 w-1/3 skeleton rounded" />
      </div>
      {/* Top right number placeholder */}
      <div className="absolute top-6 right-6 h-8 w-12 skeleton rounded" />
    </div>
  );
}

export function SectionContentSkeleton() {
  return (
    <div className="space-y-6 max-w-3xl">
      <div className="h-8 w-1/2 skeleton rounded" />
      <div className="border-b border-border pb-4" />
      <div className="space-y-3">
        <div className="h-4 w-full skeleton rounded" />
        <div className="h-4 w-11/12 skeleton rounded" />
        <div className="h-4 w-full skeleton rounded" />
        <div className="h-4 w-4/5 skeleton rounded" />
      </div>
      <div className="h-40 w-full skeleton rounded" />
      <div className="space-y-3">
        <div className="h-4 w-full skeleton rounded" />
        <div className="h-4 w-5/6 skeleton rounded" />
      </div>
    </div>
  );
}

export function QuizSkeleton() {
  return (
    <div className="space-y-6 mt-8 p-6 bg-bg-surface border border-border rounded-lg">
      <div className="h-6 w-1/3 skeleton rounded" />
      <div className="space-y-4">
        <div className="p-4 border border-border rounded space-y-2">
          <div className="h-4 w-2/3 skeleton rounded" />
          <div className="h-3 w-1/2 skeleton rounded" />
        </div>
        <div className="p-4 border border-border rounded space-y-2">
          <div className="h-4 w-3/4 skeleton rounded" />
          <div className="h-3 w-1/3 skeleton rounded" />
        </div>
      </div>
    </div>
  );
}
