import React from 'react';
import { Link, Navigate } from 'react-router-dom';
import { useAuthStore } from '../store/authStore';

const SEEDED_MODULES = [
  {
    orderIndex: 1,
    title: "Linux Fundamentals & File System",
    description: "The foundation for everything: containers, SSH, logs, and config.",
    level: "Beginner",
    totalSections: 9,
  },
  {
    orderIndex: 2,
    title: "Users, Permissions & Ownership",
    description: "The security model used in every Linux environment.",
    level: "Beginner",
    totalSections: 9,
  },
  {
    orderIndex: 3,
    title: "Processes & System Resources",
    description: "Debug crashes, monitor services, understand the kernel.",
    level: "Intermediate",
    totalSections: 7,
  },
  {
    orderIndex: 4,
    title: "Networking Basics",
    description: "Ports, DNS, SSH, sockets -- core to all distributed systems.",
    level: "Intermediate",
    totalSections: 6,
  },
  {
    orderIndex: 5,
    title: "systemd, Services & Logs",
    description: "How production services run and how to fix them.",
    level: "Intermediate",
    totalSections: 6,
  },
  {
    orderIndex: 6,
    title: "Linux for Containers & Kubernetes",
    description: "Namespaces, cgroups, the Linux primitives powering Docker and K8s.",
    level: "Advanced",
    totalSections: 6,
  },
  {
    orderIndex: 7,
    title: "Shell Scripting & Automation",
    description: "Write real DevOps tooling and automate repetitive tasks.",
    level: "Bonus",
    totalSections: 8,
  }
];

export default function LandingPage() {
  const { user } = useAuthStore();

  if (user) {
    return <Navigate to="/dashboard" replace />;
  }

  return (
    <div className="min-h-screen bg-bg-base text-text-primary font-mono flex flex-col p-4 md:p-8 select-none">
      {/* Navigation Header */}
      <header className="w-full max-w-6xl mx-auto h-14 flex items-center justify-between border-b border-border mb-8">
        <span className="font-display font-bold text-white tracking-widest text-sm">
          LINUX-MASTERY
        </span>
        <div className="flex gap-4">
          <Link to="/auth/login" className="text-xs text-text-secondary hover:text-text-primary uppercase tracking-wider">
            [Log In]
          </Link>
          <Link to="/auth/register" className="text-xs text-text-secondary hover:text-text-primary uppercase tracking-wider">
            [Get Started]
          </Link>
        </div>
      </header>

      {/* Main Container */}
      <main className="flex-1 flex flex-col items-center max-w-6xl mx-auto w-full pb-16">
        {/* Hero Section */}
        <div className="w-full border border-border p-6 md:p-12 bg-bg-surface relative overflow-hidden mb-12">
          {/* Decorative corner indicators */}
          <div className="absolute top-0 left-0 w-2 h-2 border-t border-l border-text-secondary"></div>
          <div className="absolute top-0 right-0 w-2 h-2 border-t border-r border-text-secondary"></div>
          <div className="absolute bottom-0 left-0 w-2 h-2 border-b border-l border-text-secondary"></div>
          <div className="absolute bottom-0 right-0 w-2 h-2 border-b border-r border-text-secondary"></div>

          <div className="flex items-center gap-1 mb-4 border-b border-border pb-4 flex-wrap">
            <h1 className="text-[32px] md:text-[56px] font-bold font-display uppercase tracking-wider leading-none text-text-primary">
              linux-mastery
            </h1>
            <span className="w-3.5 h-8 md:w-5 md:h-12 bg-text-primary animate-pulse flex-shrink-0" />
          </div>

          <p className="text-text-secondary mb-8 leading-relaxed text-sm md:text-base font-body max-w-3xl">
            Learn the Linux terminal, processes, system engineering, and core shell utilities through isolated Docker sandboxes and real-time feedback.
          </p>

          <div className="flex flex-col sm:flex-row gap-4 max-w-lg">
            <Link
              to="/auth/register"
              className="flex-1 text-center py-3 bg-text-primary text-bg-base font-bold border border-text-primary hover:opacity-90 transition-opacity uppercase text-xs tracking-wider"
            >
              Start Learning — Free
            </Link>
            <Link
              to="/auth/login"
              className="flex-1 text-center py-3 border border-border text-text-primary hover:border-text-primary transition-all duration-150 uppercase text-xs tracking-wider"
            >
              Access Console
            </Link>
          </div>
        </div>

        {/* Modules Slider/Grid Section */}
        <div className="w-full space-y-6">
          <h2 className="font-display font-bold text-xs uppercase tracking-wider text-text-secondary border-b border-border pb-2">
            Curriculum Modules
          </h2>

          {/* Scrollable on Mobile, Grid on Desktop */}
          <div className="flex gap-4 overflow-x-auto scroll-smooth snap-x snap-mandatory pb-4 md:grid md:grid-cols-2 lg:grid-cols-3 md:overflow-visible md:pb-0">
            {SEEDED_MODULES.map((mod) => (
              <div
                key={mod.orderIndex}
                className="snap-start min-w-[280px] w-[85%] md:w-full md:min-w-0 flex-shrink-0 relative border border-border p-6 bg-bg-surface rounded-lg flex flex-col justify-between h-56 transition-colors hover:border-text-secondary"
              >
                <span className="absolute top-6 right-6 font-display text-text-muted text-4xl font-bold">
                  {String(mod.orderIndex).padStart(2, '0')}
                </span>

                <div className="space-y-3">
                  <span className="inline-block px-2 py-0.5 text-[10px] font-mono font-medium rounded border border-border text-text-secondary bg-bg-base">
                    {mod.level}
                  </span>
                  <h3 className="font-display font-bold text-sm text-text-primary pr-12 line-clamp-2 uppercase">
                    {mod.title}
                  </h3>
                </div>

                <p className="text-text-secondary text-[11px] leading-relaxed font-body line-clamp-2 pr-4">
                  {mod.description}
                </p>

                <div className="font-mono text-[10px] text-text-muted">
                  {mod.totalSections} sections complete
                </div>
              </div>
            ))}
          </div>
        </div>

        {/* How it Works Banner */}
        <div className="w-full border border-border p-6 bg-bg-surface rounded-lg mt-12 space-y-4 font-mono text-[11px] text-text-secondary">
          <h3 className="font-display font-bold text-text-primary uppercase tracking-wider">
            SYSTEM ENGINE PIPELINE
          </h3>
          <div className="grid grid-cols-1 md:grid-cols-3 gap-6">
            <div className="flex items-start gap-2">
              <span className="text-text-primary font-bold">[1] READ:</span>
              <span>Learn core mental models and execution syntax.</span>
            </div>
            <div className="flex items-start gap-2">
              <span className="text-text-primary font-bold">[2] TERMINAL:</span>
              <span>Run live commands inside secure sandbox containers.</span>
            </div>
            <div className="flex items-start gap-2">
              <span className="text-text-primary font-bold">[3] EVALUATE:</span>
              <span>Submit timed quizzes and automated project scripts.</span>
            </div>
          </div>
        </div>
      </main>
    </div>
  );
}
