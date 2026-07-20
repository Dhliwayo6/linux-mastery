import React, { useState, useEffect } from 'react';
import { useParams, Link } from 'react-router-dom';
import { useQuery, useMutation, useQueryClient } from '@tanstack/react-query';
import ReactMarkdown from 'react-markdown';
import api from '../lib/api';
import { useToastStore } from '../store/toastStore';
import ScriptEditor from '../components/project/ScriptEditor';
import { SectionContentSkeleton } from '../components/ui/Skeletons';

export default function ProjectPage() {
  const { moduleId } = useParams();
  const queryClient = useQueryClient();
  const addToast = useToastStore((state) => state.addToast);

  const [script, setScript] = useState('');
  const [latestResult, setLatestResult] = useState(null);
  const [historyOpen, setHistoryOpen] = useState(false);

  // Fetch project brief
  const { data: project, isLoading: projectLoading, error: projectError } = useQuery({
    queryKey: ['project', moduleId],
    queryFn: async () => {
      const res = await api.get(`/project/${moduleId}`);
      return res.data.data;
    },
  });

  // Fetch submission history
  const { data: submissions, isLoading: historyLoading, refetch: refetchHistory } = useQuery({
    queryKey: ['projectHistory', moduleId],
    queryFn: async () => {
      const res = await api.get(`/project/${moduleId}/history`);
      return res.data.data;
    },
  });

  // Load default template when project loads
  useEffect(() => {
    if (project) {
      const template = project.defaultTemplate || '#!/bin/bash\n\n';
      setTimeout(() => setScript(template), 0);
    }
  }, [project]);

  const submitMutation = useMutation({
    mutationFn: async (payload) => {
      const res = await api.post(`/project/${moduleId}/submit`, payload);
      return res.data.data;
    },
    onSuccess: (data) => {
      setLatestResult(data);
      addToast(
        data.score >= 80 ? 'success' : 'warning',
        `Project submitted. Score: ${data.score}/100`
      );
      queryClient.invalidateQueries({ queryKey: ['progress'] });
      queryClient.invalidateQueries({ queryKey: ['module', moduleId] });
      refetchHistory();
    },
    onError: (err) => {
      console.error(err);
      const msg = err.response?.data?.message || 'Submission failed. Please check rate limits.';
      addToast('error', msg);
    },
  });

  if (projectLoading || historyLoading) {
    return (
      <div className="p-6 max-w-6xl mx-auto space-y-6">
        <SectionContentSkeleton />
      </div>
    );
  }

  if (projectError || !project) {
    throw projectError || new Error('Project not found');
  }

  const attemptCount = submissions ? submissions.length : 0;
  const maxAttemptsReached = attemptCount >= 3;
  const hasPassed = submissions ? submissions.some((s) => s.score >= 80) : false;

  const handleSubmit = (e) => {
    e.preventDefault();
    if (maxAttemptsReached || submitMutation.isPending) return;
    submitMutation.mutate({ script });
  };

  return (
    <div className="p-6 max-w-7xl mx-auto space-y-8 animate-fade-in pb-32 select-none">
      {/* Title block */}
      <div className="flex flex-wrap items-center justify-between gap-4 border-b border-border pb-4">
        <div>
          <h2 className="text-xl font-bold font-display uppercase tracking-wide text-text-primary">
            Module Mini-Project
          </h2>
          <p className="text-text-secondary text-xs font-body mt-1">
            Write and submit a bash script meeting the validation requirements.
          </p>
        </div>

        <Link
          to={`/modules/${moduleId}`}
          className="border border-border text-text-primary hover:bg-bg-elevated font-bold px-4 py-2 rounded text-xs transition-colors cursor-pointer"
        >
          RETURN OVERVIEW
        </Link>
      </div>

      {/* Main Split Layout */}
      <div className="grid grid-cols-1 lg:grid-cols-12 gap-8 items-start">
        {/* Left Panel: Briefing */}
        <div className="lg:col-span-5 space-y-6">
          <div className="border border-border p-6 rounded-lg bg-bg-surface space-y-4">
            <h3 className="font-display font-bold text-sm uppercase tracking-wider text-text-primary border-b border-border pb-2">
              {project.title}
            </h3>

            <div className="prose prose-invert max-w-none text-xs leading-relaxed font-body text-text-secondary space-y-4">
              <ReactMarkdown>{project.description}</ReactMarkdown>
            </div>
          </div>

          {/* Status Stats */}
          <div className="border border-border p-6 rounded-lg bg-bg-surface space-y-3 font-mono text-xs">
            <h4 className="font-bold text-text-primary uppercase">SUBMISSION STATUS</h4>
            <div className="space-y-1.5 text-text-secondary">
              <div className="flex justify-between">
                <span>ATTEMPTS ALLOWED:</span>
                <span>3 MAX</span>
              </div>
              <div className="flex justify-between">
                <span>ATTEMPTS SUBMITTED:</span>
                <span className={maxAttemptsReached ? 'text-red-400 font-bold' : ''}>
                  {attemptCount} / 3
                </span>
              </div>
              <div className="flex justify-between">
                <span>VERIFICATION SCORE:</span>
                <span>{hasPassed ? 'PASSED (>= 80)' : 'NOT PASSED'}</span>
              </div>
            </div>

            {maxAttemptsReached && !hasPassed && (
              <div className="border border-red-500/30 bg-red-950/10 p-3 rounded text-[11px] text-red-400 font-semibold uppercase text-center mt-2">
                [!] Maximum attempts reached.
              </div>
            )}

            {hasPassed && (
              <div className="border border-emerald-500/30 bg-emerald-950/10 p-3 rounded text-[11px] text-emerald-400 font-semibold uppercase text-center mt-2">
                [✓] Project successfully passed.
              </div>
            )}
          </div>
        </div>

        {/* Right Panel: Code Editor */}
        <div className="lg:col-span-7 space-y-6">
          <form onSubmit={handleSubmit} className="space-y-4">
            <div className="flex items-center justify-between text-xs text-text-secondary font-mono">
              <span>BASH SCRIPT EDITOR</span>
              <span>CHARACTERS: {script.length}</span>
            </div>

            <ScriptEditor
              value={script}
              onChange={setScript}
              readOnly={maxAttemptsReached || hasPassed || submitMutation.isPending}
            />

            {!maxAttemptsReached && !hasPassed && (
              <button
                type="submit"
                disabled={submitMutation.isPending}
                className={`w-full font-bold py-3 rounded text-sm transition-all select-none ${
                  !submitMutation.isPending
                    ? 'bg-text-primary text-black cursor-pointer hover:opacity-95'
                    : 'bg-bg-elevated border border-border text-text-muted cursor-not-allowed'
                }`}
              >
                {submitMutation.isPending ? 'RUNNING DOCKER SANDBOX GRADER...' : 'SUBMIT SCRIPT'}
              </button>
            )}
          </form>

          {/* Grader Memo Panel */}
          {latestResult && (
            <div className="border border-border p-6 rounded-lg bg-bg-surface space-y-6 animate-fade-in font-mono text-xs">
              <h3 className="font-display font-bold text-sm uppercase tracking-wider text-text-primary border-b border-border pb-2">
                Verification Report
              </h3>

              <div className="space-y-2">
                <div className="flex justify-between font-bold">
                  <span>FINAL SCORE:</span>
                  <span className={latestResult.score >= 80 ? 'text-emerald-400' : 'text-red-400'}>
                    {latestResult.score} / 100
                  </span>
                </div>
                <div className="flex justify-between font-bold">
                  <span>GRADER RESULT:</span>
                  <span className={latestResult.score >= 80 ? 'text-emerald-400' : 'text-red-400'}>
                    {latestResult.score >= 80 ? 'PASSED' : 'FAILED'}
                  </span>
                </div>
              </div>

              {/* Test cases matrix */}
              {latestResult.results && latestResult.results.length > 0 && (
                <div className="space-y-3">
                  <span className="text-text-muted font-bold block">TEST CASES</span>
                  <div className="border border-border rounded overflow-hidden divide-y divide-border bg-black">
                    {latestResult.results.map((t, idx) => (
                      <div key={t.testCaseId || idx} className="p-3 space-y-2">
                        <div className="flex items-center justify-between">
                          <span className="font-bold text-text-primary">
                            {idx + 1}. {t.description}
                          </span>
                          <span className={t.passed ? 'text-emerald-400 font-bold' : 'text-red-400 font-bold'}>
                            {t.passed ? '[✓] PASS' : '[✗] FAIL'}
                          </span>
                        </div>
                        {!t.passed && (t.expected || t.actual) && (
                          <div className="bg-bg-elevated p-2 rounded border border-border space-y-1 text-[10px] text-text-secondary overflow-x-auto">
                            <div>
                              <span className="text-text-muted">Expected: </span>
                              <span className="font-mono">{t.expected}</span>
                            </div>
                            <div>
                              <span className="text-text-muted">Actual: </span>
                              <span className="font-mono">{t.actual}</span>
                            </div>
                          </div>
                        )}
                      </div>
                    ))}
                  </div>
                </div>
              )}

              {/* Execution Memo */}
              {latestResult.memoMd && (
                <div className="space-y-2">
                  <span className="text-text-muted font-bold block">EXECUTION MEMO</span>
                  <div className="bg-black p-4 rounded border border-border prose prose-invert max-w-none text-[11px] text-text-secondary leading-relaxed overflow-x-auto">
                    <ReactMarkdown>{latestResult.memoMd}</ReactMarkdown>
                  </div>
                </div>
              )}
            </div>
          )}
        </div>
      </div>

      {/* Attempt History Log */}
      <div className="border border-border rounded-lg bg-bg-surface overflow-hidden">
        <button
          onClick={() => setHistoryOpen((prev) => !prev)}
          className="w-full flex items-center justify-between p-4 font-display font-bold text-xs uppercase tracking-wider text-text-secondary cursor-pointer hover:bg-bg-elevated transition-colors border-none outline-none"
        >
          <span>Submission Logs</span>
          <span>{historyOpen ? '[-] COLLAPSE' : '[+] EXPAND'}</span>
        </button>

        {historyOpen && (
          <div className="p-4 border-t border-border overflow-x-auto">
            {submissions?.length > 0 ? (
              <table className="min-w-full divide-y divide-border text-left font-mono text-xs">
                <thead>
                  <tr className="text-text-muted">
                    <th className="pb-2">ATTEMPT</th>
                    <th className="pb-2">DATE</th>
                    <th className="pb-2">SCORE</th>
                    <th className="pb-2">STATUS</th>
                  </tr>
                </thead>
                <tbody className="divide-y divide-border/50">
                  {submissions.map((sub) => {
                    const passed = sub.score >= 80;
                    return (
                      <tr key={sub.id} className="text-text-secondary">
                        <td className="py-2.5 font-bold">#{sub.attemptNumber}</td>
                        <td className="py-2.5">
                          {new Date(sub.createdAt).toLocaleString()}
                        </td>
                        <td className="py-2.5 font-bold">{sub.score}%</td>
                        <td className={`py-2.5 font-bold ${passed ? 'text-emerald-400' : 'text-red-400'}`}>
                          {passed ? 'PASSED' : 'FAILED'}
                        </td>
                      </tr>
                    );
                  })}
                </tbody>
              </table>
            ) : (
              <p className="text-text-muted font-body text-xs">No prior submissions recorded.</p>
            )}
          </div>
        )}
      </div>
    </div>
  );
}
