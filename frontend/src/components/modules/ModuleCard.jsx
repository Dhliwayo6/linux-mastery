import React from 'react';
import { useNavigate } from 'react-router-dom';

export default function ModuleCard({ module, locked, index }) {
  const navigate = useNavigate();

  const getLevelStyle = (level) => {
    switch (level?.toLowerCase()) {
      case 'beginner':
        return 'text-sky-400 bg-sky-950/25 border-sky-900/50';
      case 'intermediate':
        return 'text-amber-400 bg-amber-950/25 border-amber-900/50';
      case 'advanced':
        return 'text-red-400 bg-red-950/25 border-red-900/50';
      case 'bonus':
      default:
        return 'text-emerald-400 bg-emerald-950/25 border-emerald-900/50';
    }
  };

  const getLevelName = (index) => {
    // We map index to level since backend progress responses don't include levels directly
    if (index === 0 || index === 1) return 'Beginner';
    if (index >= 2 && index <= 4) return 'Intermediate';
    if (index === 5) return 'Advanced';
    return 'Bonus';
  };

  const levelName = getLevelName(index);
  const levelStyle = getLevelStyle(levelName);

  const sectionsCompleted = module.sectionsCompleted || 0;
  const totalSections = module.totalSections || 5;
  const percent = totalSections > 0 ? Math.round((sectionsCompleted / totalSections) * 100) : 0;

  // SVG ring configs
  const radius = 18;
  const circumference = 2 * Math.PI * radius;
  const strokeDashoffset = circumference - (percent / 100) * circumference;

  const handleCardClick = () => {
    if (locked) return;
    navigate(`/modules/${module.moduleId}`);
  };

  return (
    <div
      onClick={handleCardClick}
      className={`relative rounded-lg p-6 bg-bg-surface border select-none transition-all duration-300 ${
        locked
          ? 'border-border cursor-not-allowed'
          : 'border-border hover:border-text-primary cursor-pointer'
      } ${module.moduleCompleted ? 'border-[#00FF00]/40' : ''}`}
    >
      {/* Module Number */}
      <span className="absolute top-6 right-6 font-display text-text-muted text-4xl font-bold">
        {String(index + 1).padStart(2, '0')}
      </span>

      <div className="flex flex-col justify-between h-full space-y-6">
        <div className="space-y-3">
          {/* Level Badge */}
          <div className="flex items-center gap-2">
            <span className={`px-2 py-0.5 text-xs font-mono font-medium rounded border ${levelStyle}`}>
              {levelName}
            </span>
            {module.moduleCompleted && (
              <span className="px-2 py-0.5 text-xs font-mono font-medium rounded border border-emerald-500/40 text-emerald-400 bg-emerald-950/20">
                COMPLETE
              </span>
            )}
          </div>

          {/* Title */}
          <h3 className="font-display font-bold text-lg text-text-primary pr-12 line-clamp-2">
            {module.moduleTitle}
          </h3>
        </div>

        {/* Progress status */}
        <div className="flex items-center gap-4">
          <div className="relative w-12 h-12 flex items-center justify-center flex-shrink-0">
            <svg className="w-full h-full transform -rotate-90">
              <circle
                cx="24"
                cy="24"
                r={radius}
                className="stroke-bg-elevated"
                strokeWidth="2.5"
                fill="transparent"
              />
              <circle
                cx="24"
                cy="24"
                r={radius}
                className="stroke-text-primary"
                strokeWidth="2.5"
                fill="transparent"
                strokeDasharray={circumference}
                strokeDashoffset={strokeDashoffset}
                strokeLinecap="round"
              />
            </svg>
            <span className="absolute font-display text-[10px] text-text-primary font-bold">
              {percent}%
            </span>
          </div>

          <div className="font-body text-xs text-text-secondary">
            {sectionsCompleted}/{totalSections} sections complete
            {module.bestProjectScore !== null && (
              <div className="text-[10px] text-text-muted mt-0.5">
                Score: {module.bestProjectScore}/100
              </div>
            )}
          </div>
        </div>
      </div>

      {/* Lock Overlay */}
      {locked && (
        <div className="absolute inset-0 bg-black/85 backdrop-blur-[0.5px] rounded-lg flex flex-col items-center justify-center p-4 text-center">
          <svg
            className="w-8 h-8 text-text-muted mb-2"
            fill="none"
            stroke="currentColor"
            viewBox="0 0 24 24"
          >
            <rect x="3" y="11" width="18" height="11" rx="2" ry="2" strokeWidth="2" />
            <path d="M7 11V7a5 5 0 0110 0v4" strokeWidth="2" />
          </svg>
          <p className="font-display text-xs text-text-muted font-bold uppercase tracking-wider">
            Locked
          </p>
          <p className="font-body text-[10px] text-text-muted mt-1">
            Complete Module {index} first
          </p>
        </div>
      )}
    </div>
  );
}
