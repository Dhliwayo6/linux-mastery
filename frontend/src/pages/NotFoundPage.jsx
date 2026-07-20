import React from 'react';
import { Link } from 'react-router-dom';

export default function NotFoundPage() {
  return (
    <div className="min-h-screen bg-black text-white font-mono flex flex-col items-center justify-center p-6 select-none">
      <div className="max-w-lg w-full bg-black border border-border p-6 rounded-lg space-y-4 shadow-2xl">
        <div className="flex items-center justify-between text-xs text-text-muted border-b border-border pb-3">
          <span>SHELL - SESSION_ERROR</span>
          <span className="flex gap-1.5">
            <span className="w-2.5 h-2.5 rounded-full bg-border" />
            <span className="w-2.5 h-2.5 rounded-full bg-border" />
            <span className="w-2.5 h-2.5 rounded-full bg-border" />
          </span>
        </div>
        <div className="space-y-2 text-sm leading-relaxed">
          <div className="flex items-center gap-2">
            <span className="text-text-muted">$</span>
            <span className="text-text-primary">_</span>
            <span className="w-2.5 h-4 bg-[#00FF00] animate-pulse" />
          </div>
          <div className="text-text-primary font-bold">404: path not found</div>
          <div className="text-text-secondary">
            cd / to return home
          </div>
        </div>
        <div className="pt-4">
          <Link
            to="/dashboard"
            className="inline-block bg-[#00FF00] text-black font-bold px-4 py-2 rounded text-xs hover:opacity-85 transition-opacity cursor-pointer"
          >
            cd /dashboard
          </Link>
        </div>
      </div>
    </div>
  );
}
