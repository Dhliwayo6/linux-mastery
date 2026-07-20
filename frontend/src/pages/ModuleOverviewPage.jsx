import React from 'react';
import { useParams, useNavigate, Link } from 'react-router-dom';
import { useQuery } from '@tanstack/react-query';
import api from '../lib/api';
import { SectionContentSkeleton } from '../components/ui/Skeletons';

export default function ModuleOverviewPage() {
  const { moduleId } = useParams();
  const navigate = useNavigate();

  // Query module details
  const { data: module, isLoading: moduleLoading, error: moduleError } = useQuery({
    queryKey: ['module', moduleId],
    queryFn: async () => {
      const res = await api.get(`/modules/${moduleId}`);
      return res.data.data;
    },
  });

  // Query progress list to get assessmentPassed and project score details
  const { data: progressList, isLoading: progressLoading } = useQuery({
    queryKey: ['progress'],
    queryFn: async () => {
      const res = await api.get('/progress');
      return res.data.data;
    },
  });

  if (moduleLoading || progressLoading) {
    return (
      <div className="p-6 max-w-4xl mx-auto space-y-6">
        <SectionContentSkeleton />
      </div>
    );
  }

  if (moduleError || !module) {
    throw moduleError || new Error('Module not found');
  }

  const progress = progressList?.find((p) => p.moduleId === moduleId);
  const assessmentPassed = progress?.assessmentPassed || false;
  const bestProjectScore = progress?.bestProjectScore;

  // Level Style Mapping
  const getLevelStyle = (level) => {
    switch (level?.toLowerCase()) {
      case 'beginner':
        return 'text-sky-400 bg-sky-950/20 border border-sky-900/50';
      case 'intermediate':
        return 'text-amber-400 bg-amber-950/20 border border-amber-900/50';
      case 'advanced':
        return 'text-red-400 bg-red-950/20 border border-red-900/50';
      case 'bonus':
      default:
        return 'text-emerald-400 bg-emerald-950/20 border border-emerald-900/50';
    }
  };

  const firstIncompleteSection = module.sections?.find((s) => !s.completed);
  const continueSection = firstIncompleteSection || module.sections?.[0];
  const allSectionsCompleted = module.sectionsCompleted === module.totalSections;

  return (
    <div className="p-6 max-w-4xl mx-auto space-y-8 animate-fade-in">
      {/* Title block */}
      <div className="border border-border p-6 bg-bg-surface rounded-lg space-y-4">
        <div className="flex flex-wrap items-center gap-3">
          <span className={`px-2 py-0.5 text-xs font-mono font-medium rounded ${getLevelStyle(module.level)}`}>
            {module.level}
          </span>
          {module.completed && (
            <span className="px-2 py-0.5 text-xs font-mono font-medium rounded border border-emerald-500/40 text-emerald-400 bg-emerald-950/20">
              COMPLETE
            </span>
          )}
        </div>

        <div className="space-y-2">
          <h2 className="text-2xl font-bold font-display uppercase tracking-wide text-text-primary">
            {module.title}
          </h2>
          <p className="text-text-secondary text-sm leading-relaxed font-body">
            {module.description}
          </p>
        </div>

        <div className="border-t border-border pt-4 flex flex-wrap gap-4 items-center justify-between">
          <div className="text-xs text-text-secondary font-mono">
            PROGRESS: {module.sectionsCompleted} / {module.totalSections} SECTIONS COMPLETE
          </div>

          <div className="flex gap-3">
            {continueSection && !allSectionsCompleted && (
              <button
                onClick={() => navigate(`/modules/${moduleId}/sections/${continueSection.id}`)}
                className="bg-text-primary text-black font-bold px-4 py-2 rounded text-xs hover:opacity-90 transition-opacity cursor-pointer"
              >
                {module.sectionsCompleted > 0 ? 'CONTINUE LESSON' : 'START LESSON'}
              </button>
            )}

            {allSectionsCompleted && (
              <Link
                to={`/modules/${moduleId}/assessment`}
                className={`font-bold px-4 py-2 rounded text-xs transition-opacity cursor-pointer ${
                  assessmentPassed
                    ? 'border border-[#00FF00]/40 text-[#00FF00] bg-emerald-950/10 hover:opacity-90'
                    : 'bg-text-primary text-black hover:opacity-90'
                }`}
              >
                {assessmentPassed ? 'VIEW ASSESSMENT RESULT' : 'TAKE ASSESSMENT'}
              </Link>
            )}

            {assessmentPassed && (
              <Link
                to={`/modules/${moduleId}/project`}
                className={`font-bold px-4 py-2 rounded text-xs transition-opacity cursor-pointer ${
                  bestProjectScore !== null
                    ? 'border border-text-primary text-text-primary hover:bg-bg-elevated'
                    : 'bg-text-primary text-black hover:opacity-90'
                }`}
              >
                {bestProjectScore !== null ? `VIEW PROJECT (SCORE: ${bestProjectScore})` : 'SUBMIT MINI PROJECT'}
              </Link>
            )}
          </div>
        </div>
      </div>

      {/* Sections breakdown */}
      <div className="space-y-4">
        <h3 className="font-display font-bold text-sm uppercase tracking-wider text-text-secondary border-b border-border pb-2">
          Curriculum breakdown
        </h3>

        <div className="border border-border rounded-lg bg-bg-surface overflow-hidden divide-y divide-border">
          {module.sections?.map((section, idx) => {
            const isUnlocked = section.unlocked;
            const isCompleted = section.completed;

            return (
              <div
                key={section.id}
                className={`p-4 flex items-center justify-between transition-colors ${
                  isUnlocked ? 'hover:bg-bg-elevated' : 'opacity-50'
                }`}
              >
                <div className="flex items-center gap-4 flex-1">
                  {/* Status glyph */}
                  <span className="font-mono text-xs text-text-muted select-none w-6">
                    {String(idx + 1).padStart(2, '0')}
                  </span>
                  
                  {isUnlocked ? (
                    <Link
                      to={`/modules/${moduleId}/sections/${section.id}`}
                      className="font-display text-sm text-text-primary hover:underline font-bold text-left flex-1"
                    >
                      {section.title}
                    </Link>
                  ) : (
                    <span className="font-display text-sm text-text-muted font-bold text-left flex-1">
                      {section.title} (Locked)
                    </span>
                  )}
                </div>

                <div className="flex items-center gap-3">
                  {isCompleted ? (
                    <span className="text-emerald-400 font-mono text-xs flex items-center gap-1">
                      <span>[✓]</span>
                      <span className="hidden sm:inline">COMPLETE</span>
                    </span>
                  ) : isUnlocked ? (
                    <span className="text-text-muted font-mono text-xs flex items-center gap-1">
                      <span>[ ]</span>
                      <span className="hidden sm:inline">UNLOCKED</span>
                    </span>
                  ) : (
                    <span className="text-text-muted font-mono text-xs flex items-center gap-1">
                      <span>[✗]</span>
                      <span className="hidden sm:inline">LOCKED</span>
                    </span>
                  )}
                </div>
              </div>
            );
          })}
        </div>
      </div>
    </div>
  );
}
