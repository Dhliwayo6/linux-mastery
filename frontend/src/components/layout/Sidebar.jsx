import React, { useState, useEffect, useRef } from 'react';
import { NavLink, useParams, useLocation } from 'react-router-dom';
import { useQuery } from '@tanstack/react-query';
import { api } from '../../lib/api';

export default function Sidebar({ isOpen, onClose }) {
  const { moduleId } = useParams();
  const location = useLocation();
  const lastPathnameRef = useRef(location.pathname);
  const [expandedModules, setExpandedModules] = useState(() => {
    return moduleId ? { [moduleId]: true } : {};
  });

  // Fetch modules data
  const { data: modules, isLoading } = useQuery({
    queryKey: ['modules'],
    queryFn: async () => {
      const { data } = await api.get('/api/v1/modules');
      return data.data;
    },
  });

  // Close mobile sidebar on route change
  useEffect(() => {
    if (lastPathnameRef.current !== location.pathname) {
      lastPathnameRef.current = location.pathname;
      if (onClose) {
        onClose();
      }
    }
  }, [location.pathname, onClose]);

  const toggleModule = (id) => {
    setExpandedModules((prev) => ({ ...prev, [id]: !prev[id] }));
  };

  const getStatusIcon = (item) => {
    if (!item.unlocked) {
      // Locked: hollow grey circle with lock glyph
      return (
        <span className="inline-flex items-center justify-center mr-2 w-4 h-4 text-text-muted flex-shrink-0">
          <svg className="w-3.5 h-3.5" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2">
            <circle cx="12" cy="12" r="10" />
            <rect x="9" y="11" width="6" height="5" rx="1" strokeWidth="1.5" />
            <path d="M10 11V9a2 2 0 014 0v2" strokeWidth="1.5" />
          </svg>
        </span>
      );
    }

    if (!item.completed) {
      // In progress: half-filled circle
      return (
        <span className="inline-flex items-center justify-center mr-2 w-4 h-4 text-text-secondary flex-shrink-0">
          <svg className="w-3.5 h-3.5" viewBox="0 0 24 24" fill="none">
            <circle cx="12" cy="12" r="10" stroke="currentColor" strokeWidth="2" />
            <path d="M12 2A10 10 0 0012 22V2z" fill="currentColor" />
          </svg>
        </span>
      );
    }

    // Completed: solid white circle with black check glyph
    return (
      <span className="inline-flex items-center justify-center mr-2 w-4 h-4 text-text-primary flex-shrink-0">
        <svg className="w-3.5 h-3.5" viewBox="0 0 24 24" fill="currentColor">
          <circle cx="12" cy="12" r="10" />
          <path d="M9 12l2 2 4-4" fill="none" stroke="black" strokeWidth="2.5" strokeLinecap="round" strokeLinejoin="round" />
        </svg>
      </span>
    );
  };

  return (
    <>
      {/* Mobile/Tablet Drawer Backdrop */}
      {isOpen && (
        <div
          className="fixed inset-0 z-20 bg-black/85 lg:hidden"
          onClick={onClose}
        />
      )}

      {/* Sidebar Container */}
      <aside
        className={`fixed inset-y-0 left-0 z-30 w-full md:w-60 lg:w-16 xl:w-60 border-r border-border bg-bg-base flex flex-col transform transition-transform duration-200 ease-in-out motion-reduce:transition-none lg:relative lg:translate-x-0 ${
          isOpen ? 'translate-x-0' : '-translate-x-full lg:translate-x-0'
        }`}
      >
        {/* Mobile/Tablet Header close bar */}
        <div className="h-14 border-b border-border flex items-center justify-between px-4 lg:hidden">
          <span className="font-display text-xs font-bold uppercase tracking-wider text-text-secondary">Navigation</span>
          <button onClick={onClose} className="p-1 border border-border text-text-primary hover:bg-bg-elevated">
            <svg className="w-4 h-4" fill="none" viewBox="0 0 24 24" stroke="currentColor">
              <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={2} d="M6 18L18 6M6 6l12 12" />
            </svg>
          </button>
        </div>

        <div className="flex-1 overflow-y-auto p-4 lg:p-2 xl:p-4 space-y-4 select-none">
          {isLoading ? (
            <div className="space-y-4">
              {[1, 2, 3].map((n) => (
                <div key={n} className="animate-pulse space-y-2">
                  <div className="h-4 bg-bg-elevated w-3/4 lg:w-full"></div>
                  <div className="h-3 bg-bg-elevated w-1/2 lg:hidden ml-4"></div>
                </div>
              ))}
            </div>
          ) : (
            modules?.map((mod) => {
              const isExpanded = !!expandedModules[mod.id];
              const isActiveMod = moduleId === mod.id;

              return (
                <div key={mod.id} className="border border-border">
                  {/* Module Header */}
                  <button
                    onClick={() => toggleModule(mod.id)}
                    disabled={!mod.unlocked}
                    title={mod.title}
                    aria-label={mod.title}
                    className={`w-full flex items-center justify-between lg:justify-center xl:justify-between p-3 lg:p-2 xl:p-3 text-left transition-colors duration-150 ${
                      !mod.unlocked
                        ? 'opacity-40 cursor-not-allowed bg-bg-base'
                        : isActiveMod
                        ? 'bg-bg-surface text-text-primary'
                        : 'bg-bg-base text-text-secondary hover:text-text-primary hover:bg-bg-surface'
                    }`}
                  >
                    {/* Compact Rail Mode Content */}
                    <div className="hidden lg:flex xl:hidden w-full flex-col items-center justify-center py-1 gap-1">
                      {mod.unlocked ? (
                        <span className="text-xs font-mono font-bold text-text-primary">
                          0{mod.orderIndex}
                        </span>
                      ) : (
                        <span className="text-text-muted">
                          <svg className="w-3.5 h-3.5" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2">
                            <rect x="9" y="11" width="6" height="5" rx="1" strokeWidth="1.5" />
                            <path d="M10 11V9a2 2 0 014 0v2" strokeWidth="1.5" />
                          </svg>
                        </span>
                      )}
                    </div>

                    {/* Standard Mode Left Panel */}
                    <div className="flex flex-col min-w-0 pr-2 lg:hidden xl:flex">
                      <span className="text-[10px] font-mono uppercase text-text-muted">
                        Module 0{mod.orderIndex}
                      </span>
                      <span className="text-xs font-bold font-display uppercase tracking-wide truncate">
                        {mod.title}
                      </span>
                    </div>

                    {/* Standard Mode Right Panel */}
                    <div className="flex items-center gap-2 flex-shrink-0 font-mono lg:hidden xl:flex">
                      {mod.unlocked ? (
                        <>
                          <span className="text-[10px] text-text-muted">
                            {mod.sectionsCompleted}/{mod.totalSections}
                          </span>
                          <svg
                            className={`w-3.5 h-3.5 transition-transform duration-150 ${isExpanded ? 'rotate-180' : ''}`}
                            fill="none"
                            viewBox="0 0 24 24"
                            stroke="currentColor"
                          >
                            <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={2} d="M19 9l-7 7-7-7" />
                          </svg>
                        </>
                      ) : (
                        getStatusIcon(mod)
                      )}
                    </div>
                  </button>

                  {/* Module Content (Expanded) */}
                  {mod.unlocked && isExpanded && (
                    <div className="border-t border-border bg-bg-base py-1 lg:hidden xl:block">
                      {/* Sections List */}
                      {mod.sections?.map((sec) => (
                        <NavLink
                          key={sec.id}
                          to={`/modules/${mod.id}/sections/${sec.id}`}
                          className={({ isActive }) =>
                            `flex items-center py-2 pl-3 pr-2 text-xs font-mono transition-colors duration-150 ${
                              isActive
                                ? 'border-l-2 border-white bg-bg-elevated text-text-primary font-bold'
                                : sec.unlocked
                                ? 'text-text-secondary hover:text-text-primary border-l-2 border-transparent'
                                : 'text-text-muted border-l-2 border-transparent cursor-not-allowed opacity-50'
                            }`
                          }
                          onClick={(e) => {
                            if (!sec.unlocked) e.preventDefault();
                          }}
                        >
                          {getStatusIcon(sec)}
                          <span className="truncate">{sec.title}</span>
                        </NavLink>
                      ))}

                      {/* Assessment Link */}
                      <NavLink
                        to={`/modules/${mod.id}/assessment`}
                        className={({ isActive }) => {
                          const unlocked = mod.sectionsCompleted === mod.totalSections;
                          return `flex items-center py-2 pl-3 pr-2 text-xs font-mono transition-colors duration-150 border-t border-border/40 mt-1 ${
                            isActive
                              ? 'border-l-2 border-white bg-bg-elevated text-text-primary font-bold'
                              : unlocked
                              ? 'text-text-secondary hover:text-text-primary border-l-2 border-transparent'
                              : 'text-text-muted border-l-2 border-transparent cursor-not-allowed opacity-50'
                          }`;
                        }}
                        onClick={(e) => {
                          const unlocked = mod.sectionsCompleted === mod.totalSections;
                          if (!unlocked) e.preventDefault();
                        }}
                      >
                        {getStatusIcon(
                          {
                            unlocked: mod.sectionsCompleted === mod.totalSections,
                            completed: mod.completed,
                          }
                        )}
                        <span className="italic">[Assessment]</span>
                      </NavLink>

                      {/* Project Link */}
                      <NavLink
                        to={`/modules/${mod.id}/project`}
                        className={({ isActive }) => {
                          const unlocked = mod.sectionsCompleted === mod.totalSections;
                          return `flex items-center py-2 pl-3 pr-2 text-xs font-mono transition-colors duration-150 ${
                            isActive
                              ? 'border-l-2 border-white bg-bg-elevated text-text-primary font-bold'
                              : unlocked
                              ? 'text-text-secondary hover:text-text-primary border-l-2 border-transparent'
                              : 'text-text-muted border-l-2 border-transparent cursor-not-allowed opacity-50'
                          }`;
                        }}
                        onClick={(e) => {
                          const unlocked = mod.sectionsCompleted === mod.totalSections;
                          if (!unlocked) e.preventDefault();
                        }}
                      >
                        {getStatusIcon(
                          {
                            unlocked: mod.sectionsCompleted === mod.totalSections,
                            completed: mod.completed,
                          }
                        )}
                        <span className="italic">[Mini-Project]</span>
                      </NavLink>
                    </div>
                  )}
                </div>
              );
            })
          )}
        </div>
      </aside>
    </>
  );
}
