import React from 'react';
import { useQuery } from '@tanstack/react-query';
import api from '../lib/api';
import { useAuthStore } from '../store/authStore';
import ModuleCard from '../components/modules/ModuleCard';
import { ModuleCardSkeleton } from '../components/ui/Skeletons';

export default function DashboardPage() {
  const { user } = useAuthStore();

  const { data: progressList, isLoading, error } = useQuery({
    queryKey: ['progress'],
    queryFn: async () => {
      const res = await api.get('/progress');
      return res.data.data;
    },
  });

  if (isLoading) {
    return (
      <div className="p-6 max-w-6xl mx-auto space-y-6">
        <div className="border border-border p-6 bg-bg-surface rounded-lg space-y-4">
          <div className="h-8 w-1/3 skeleton rounded" />
          <div className="h-4 w-1/4 skeleton rounded" />
        </div>
        <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-6">
          {Array.from({ length: 7 }).map((_, i) => (
            <ModuleCardSkeleton key={i} />
          ))}
        </div>
      </div>
    );
  }

  if (error) {
    throw error; // Let the ErrorBoundary catch this
  }

  const completedCount = progressList ? progressList.filter((m) => m.moduleCompleted).length : 0;
  const courseComplete = completedCount === 7;

  return (
    <div className="p-6 max-w-6xl mx-auto space-y-8 animate-fade-in">
      {/* Header Panel */}
      <div className="border border-border p-6 bg-bg-surface rounded-lg flex flex-col md:flex-row md:items-center justify-between gap-6">
        <div className="space-y-2">
          <h2 className="text-2xl font-bold font-display uppercase tracking-wide text-text-primary">
            Welcome back, {user?.displayName || user?.email || 'Student'}
          </h2>
          <p className="text-text-secondary text-sm font-body">
            Initialize a module from the grid below or sidebar navigation to resume your learning.
          </p>
        </div>

        {/* Progress tracker */}
        <div className="md:text-right min-w-[200px] space-y-2">
          <div className="font-display text-sm font-bold uppercase tracking-wider text-text-primary">
            Overall Curriculum
          </div>
          <div className="font-body text-xs text-text-secondary">
            {completedCount} / 7 modules complete
          </div>
          <div className="w-full bg-bg-elevated h-2.5 rounded-full overflow-hidden border border-border">
            <div
              className="bg-text-primary h-full transition-all duration-500 rounded-full"
              style={{ width: `${(completedCount / 7) * 100}%` }}
            />
          </div>
        </div>
      </div>

      {/* Course Completed Banner */}
      {courseComplete && (
        <div className="border border-emerald-500/30 p-6 bg-emerald-950/15 rounded-lg flex flex-col md:flex-row items-center gap-6 justify-between animate-pulse">
          <div className="space-y-1">
            <h3 className="font-display font-bold text-emerald-400 text-lg uppercase tracking-wider">
              [✓] Curriculum Mastered
            </h3>
            <p className="font-body text-xs text-emerald-300/80">
              Congratulations! You have completed all 7 core modules, assessments, and projects.
            </p>
          </div>
          <div className="border border-emerald-400/40 p-4 rounded bg-black/60 font-mono text-[10px] text-emerald-400 select-all shadow-inner text-center">
            <div className="font-bold border-b border-emerald-400/20 pb-1 mb-1.5 uppercase">
              Linux Mastery Certificate
            </div>
            <div>UID: {user?.id?.substring(0, 8)}</div>
            <div>STATUS: CERTIFIED_EXPERT</div>
            <div>COMPLETED: {new Date().toLocaleDateString()}</div>
          </div>
        </div>
      )}

      {/* Modules Grid */}
      <div className="space-y-4">
        <h3 className="font-display font-bold text-sm uppercase tracking-wider text-text-secondary border-b border-border pb-2">
          Seeded Modules
        </h3>
        <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-6">
          {progressList?.map((moduleProgress, index) => {
            // Unlocked if first module or previous module is completed
            const locked = index > 0 && !progressList[index - 1].moduleCompleted;

            return (
              <ModuleCard
                key={moduleProgress.moduleId || index}
                module={moduleProgress}
                locked={locked}
                index={index}
              />
            );
          })}
        </div>
      </div>
    </div>
  );
}
