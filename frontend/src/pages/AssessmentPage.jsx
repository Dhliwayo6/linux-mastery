import React, { useState, useEffect, useRef, useCallback } from 'react';
import { useParams, useBeforeUnload, Link } from 'react-router-dom';
import { useQuery, useMutation, useQueryClient } from '@tanstack/react-query';
import api from '../lib/api';
import { useToastStore } from '../store/toastStore';
import AssessmentTimer from '../components/assessment/AssessmentTimer';
import { SectionContentSkeleton } from '../components/ui/Skeletons';

export default function AssessmentPage() {
  const { moduleId } = useParams();
  const queryClient = useQueryClient();
  const addToast = useToastStore((state) => state.addToast);

  const [answers, setAnswers] = useState({});
  const [currentIndex, setCurrentIndex] = useState(0);
  const [submitted, setSubmitted] = useState(false);
  const [result, setResult] = useState(null);
  const [historyOpen, setHistoryOpen] = useState(false);

  const startTimeRef = useRef(null);

  // Initialize start time on load
  useEffect(() => {
    startTimeRef.current = Date.now();
  }, [moduleId]);

  // Fetch assessment questions
  const { data: questions, isLoading: questionsLoading, error: questionsError } = useQuery({
    queryKey: ['assessment', moduleId],
    queryFn: async () => {
      const res = await api.get(`/assessment/${moduleId}`);
      return res.data.data;
    },
    enabled: !submitted, // Only load when not submitted
  });

  // Fetch attempt history
  const { data: historyList, refetch: refetchHistory } = useQuery({
    queryKey: ['assessmentHistory', moduleId],
    queryFn: async () => {
      const res = await api.get(`/assessment/${moduleId}/history`);
      return res.data.data;
    },
  });

  // Prevent routing away
  useBeforeUnload(
    useCallback(
      (e) => {
        if (!submitted && Object.keys(answers).length > 0) {
          e.preventDefault();
        }
      },
      [submitted, answers]
    )
  );

  const submitMutation = useMutation({
    mutationFn: async (payload) => {
      const res = await api.post(`/assessment/${moduleId}/submit`, payload);
      return res.data.data;
    },
    onSuccess: (data) => {
      setResult(data);
      setSubmitted(true);
      addToast(
        data.passed ? 'success' : 'warning',
        data.passed ? 'Chapter assessment passed! ✓' : `Assessment failed: ${data.score}%`
      );
      queryClient.invalidateQueries({ queryKey: ['progress'] });
      queryClient.invalidateQueries({ queryKey: ['module', moduleId] });
      refetchHistory();
    },
    onError: (err) => {
      console.error(err);
      addToast('error', 'Something went wrong. Please try again.');
    },
  });

  if (questionsLoading) {
    return (
      <div className="p-4 sm:p-6 max-w-4xl mx-auto space-y-6">
        <SectionContentSkeleton />
      </div>
    );
  }

  if (questionsError || !questions) {
    throw questionsError || new Error('Failed to load assessment questions');
  }

  const currentQuestion = questions[currentIndex];
  const allAnswered = questions.length > 0 && questions.every((q) => answers[q.id]);

  const handleOptionSelect = (val) => {
    if (submitted) return;
    setAnswers((prev) => ({
      ...prev,
      [currentQuestion.id]: val,
    }));
  };

  const handleNext = () => {
    if (currentIndex < questions.length - 1) {
      setCurrentIndex((prev) => prev + 1);
    }
  };

  const handlePrev = () => {
    if (currentIndex > 0) {
      setCurrentIndex((prev) => prev - 1);
    }
  };

  const executeSubmit = () => {
    if (submitMutation.isPending) return;

    const durationSecs = Math.max(
      1,
      Math.min(900, Math.floor((Date.now() - startTimeRef.current) / 1000))
    );

    // If some unanswered, default to empty string
    const formattedAnswers = questions.map((q) => ({
      questionId: q.id,
      selectedAnswer: answers[q.id] || '',
    }));

    submitMutation.mutate({
      answers: formattedAnswers,
      durationSecs,
    });
  };

  const handleAutoSubmit = () => {
    if (submitted) return;
    addToast('warning', 'Time expired! Auto-submitting.');
    executeSubmit();
  };

  const handleRetake = () => {
    setAnswers({});
    setCurrentIndex(0);
    setSubmitted(false);
    setResult(null);
    startTimeRef.current = Date.now();
  };

  return (
    <div className="p-4 sm:p-6 max-w-4xl mx-auto space-y-6 sm:space-y-8 animate-fade-in pb-24 select-none">
      {/* Title & Timer bar */}
      <div className="sticky top-0 z-10 bg-bg-base/95 backdrop-blur-sm py-3 border-b border-border flex items-center justify-between gap-4">
        <div>
          <h2 className="text-sm sm:text-xl font-bold font-display uppercase tracking-wide text-text-primary">
            Chapter Assessment
          </h2>
          <p className="text-text-secondary text-xs font-body mt-1 hidden sm:block">
            Complete the 10-question evaluation to unlock the module project.
          </p>
        </div>

        {!submitted && (
          <AssessmentTimer onExpire={handleAutoSubmit} />
        )}
      </div>

      {/* Answer status grid */}
      <div className="space-y-3">
        <div className="flex items-center justify-between text-xs text-text-secondary font-mono">
          <span>NAVIGATION MATRIX</span>
          <span>{Object.keys(answers).length} / 10 ANSWERED</span>
        </div>
        <div className="grid grid-cols-5 sm:grid-cols-10 gap-3">
          {questions.map((q, idx) => {
            const isAnswered = !!answers[q.id];
            const isCurrent = idx === currentIndex;

            // feedback glyphs post-submit
            let glyph = String(idx + 1);
            let borderStyle = 'border-border';
            let bgStyle = 'bg-bg-surface';
            let textStyle = 'text-text-secondary';

            if (submitted && result) {
              const fb = result.feedback?.find((f) => f.questionId === q.id);
              if (fb) {
                glyph = fb.correct ? '✓' : '✗';
                borderStyle = fb.correct ? 'border-emerald-500/40' : 'border-red-500/40';
                bgStyle = fb.correct ? 'bg-emerald-950/20' : 'bg-red-950/20';
                textStyle = fb.correct ? 'text-emerald-400' : 'text-red-400';
              }
            } else {
              if (isCurrent) {
                borderStyle = 'border-text-primary';
                textStyle = 'text-text-primary font-bold';
              } else if (isAnswered) {
                bgStyle = 'bg-text-primary';
                textStyle = 'text-black font-bold';
                borderStyle = 'border-text-primary';
              }
            }

            return (
              <button
                key={q.id}
                type="button"
                onClick={() => setCurrentIndex(idx)}
                className={`h-10 border rounded font-mono text-sm flex items-center justify-center cursor-pointer transition-all ${borderStyle} ${bgStyle} ${textStyle}`}
              >
                {glyph}
              </button>
            );
          })}
        </div>
      </div>

      {/* Main question panel OR Result panel */}
      {!submitted ? (
        <div className="space-y-6">
          {/* Question text */}
          <div className="border border-border p-6 rounded-lg bg-bg-surface space-y-4">
            <div className="text-xs text-text-muted font-mono">
              QUESTION {currentIndex + 1} OF 10
            </div>
            <h3 className="font-display font-bold text-sm text-text-primary leading-relaxed">
              {currentQuestion.questionText}
            </h3>
          </div>

          {/* Options */}
          <div className="grid grid-cols-1 gap-3">
            {currentQuestion.options?.map((option) => {
              const isSelected = answers[currentQuestion.id] === option.id;
              return (
                <button
                  type="button"
                  key={option.id}
                  onClick={() => handleOptionSelect(option.id)}
                  className={`w-full text-left p-4 border rounded font-body text-sm cursor-pointer transition-all ${
                    isSelected
                      ? 'border-text-primary bg-bg-elevated text-text-primary'
                      : 'border-border hover:border-text-secondary bg-bg-surface text-text-secondary'
                  }`}
                >
                  <span className="font-bold mr-2 uppercase">{option.id}.</span>
                  {option.text}
                </button>
              );
            })}
          </div>

          {/* Nav buttons */}
          <div className="flex items-center justify-between border-t border-border pt-4">
            <button
              onClick={handlePrev}
              disabled={currentIndex === 0}
              className={`px-4 py-2 border rounded font-display text-xs font-bold uppercase transition-all ${
                currentIndex === 0
                  ? 'border-border text-text-muted cursor-not-allowed opacity-50'
                  : 'border-border text-text-secondary hover:border-text-primary cursor-pointer'
              }`}
            >
              PREVIOUS
            </button>

            {currentIndex === questions.length - 1 ? (
              <button
                onClick={executeSubmit}
                disabled={!allAnswered || submitMutation.isPending}
                className={`font-bold px-6 py-2.5 rounded text-xs select-none ${
                  allAnswered && !submitMutation.isPending
                    ? 'bg-text-primary text-black cursor-pointer hover:opacity-95'
                    : 'bg-bg-elevated border border-border text-text-muted cursor-not-allowed'
                }`}
              >
                {submitMutation.isPending ? 'GRADING ASSESSMENT...' : 'SUBMIT ASSESSMENT'}
              </button>
            ) : (
              <button
                onClick={handleNext}
                className="px-4 py-2 border border-border rounded font-display text-xs font-bold uppercase hover:border-text-primary text-text-secondary cursor-pointer"
              >
                NEXT
              </button>
            )}
          </div>
        </div>
      ) : (
        /* Result Panel */
        result && (
          <div className="space-y-6">
            <div
              className={`border p-6 rounded-lg font-mono text-sm space-y-4 ${
                result.passed
                  ? 'border-emerald-500/30 bg-emerald-950/10 text-emerald-400'
                  : 'border-red-500/30 bg-red-950/10 text-red-400'
              }`}
            >
              <div className="font-display font-bold text-base uppercase">
                {result.passed ? '[✓] Assessment Passed' : '[✗] Assessment Failed'}
              </div>
              <div className="font-body text-xs text-text-secondary">
                Your Score: <span className="font-bold text-text-primary">{result.score}%</span> (Required: 60%)
              </div>

              <div className="flex gap-4 pt-2">
                {result.passed ? (
                  <Link
                    to={`/modules/${moduleId}/project`}
                    className="bg-emerald-500 text-black font-bold px-4 py-2 rounded text-xs hover:bg-emerald-400 transition-colors cursor-pointer text-center"
                  >
                    CONTINUE TO PROJECT →
                  </Link>
                ) : (
                  <button
                    onClick={handleRetake}
                    className="bg-text-primary text-black font-bold px-4 py-2 rounded text-xs hover:opacity-90 cursor-pointer text-center"
                  >
                    RETAKE ASSESSMENT
                  </button>
                )}

                <Link
                  to={`/modules/${moduleId}`}
                  className="border border-border text-text-primary hover:bg-bg-elevated font-bold px-4 py-2 rounded text-xs transition-colors cursor-pointer text-center"
                >
                  MODULE OVERVIEW
                </Link>
              </div>
            </div>

            {/* Questions detail review */}
            <div className="space-y-4">
              <h3 className="font-display font-bold text-sm uppercase tracking-wider text-text-secondary border-b border-border pb-2">
                Review Questions
              </h3>

              <div className="space-y-4">
                {questions.map((q, idx) => {
                  const fb = result.feedback?.find((f) => f.questionId === q.id);
                  if (!fb) return null;

                  return (
                    <div
                      key={q.id}
                      className={`p-6 border rounded-lg bg-bg-surface/50 space-y-3 ${
                        fb.correct ? 'border-emerald-500/20' : 'border-red-500/20'
                      }`}
                    >
                      <div className="flex items-center justify-between text-xs font-mono">
                        <span className="text-text-muted">QUESTION {idx + 1}</span>
                        <span className={fb.correct ? 'text-emerald-400 font-bold' : 'text-red-400 font-bold'}>
                          {fb.correct ? '[✓] CORRECT' : '[✗] INCORRECT'}
                        </span>
                      </div>

                      <h4 className="font-display font-bold text-sm text-text-primary">
                        {q.questionText}
                      </h4>

                      <div className="text-xs space-y-1 font-body">
                        <div>
                          <span className="text-text-muted">Your answer: </span>
                          <span className="font-mono">{fb.selectedAnswer || '(No answer)'}</span>
                        </div>
                        <div>
                          <span className="text-text-muted">Correct answer: </span>
                          <span className="font-mono">{fb.correctAnswer}</span>
                        </div>
                      </div>

                      <div className="border-t border-border/50 pt-2 text-xs font-body">
                        <span className="text-text-muted font-mono text-[10px] uppercase block mb-1">Explanation</span>
                        <p className="text-text-secondary leading-relaxed">{fb.explanation}</p>
                      </div>
                    </div>
                  );
                })}
              </div>
            </div>
          </div>
        )
      )}

      {/* Attempt History Section */}
      <div className="border border-border rounded-lg bg-bg-surface overflow-hidden">
        <button
          onClick={() => setHistoryOpen((prev) => !prev)}
          className="w-full flex items-center justify-between p-4 font-display font-bold text-xs uppercase tracking-wider text-text-secondary cursor-pointer hover:bg-bg-elevated transition-colors border-none outline-none"
        >
          <span>Attempt History</span>
          <span>{historyOpen ? '[-] COLLAPSE' : '[+] EXPAND'}</span>
        </button>

        {historyOpen && (
          <div className="p-4 border-t border-border overflow-x-auto">
            {historyList?.length > 0 ? (
              <table className="min-w-full divide-y divide-border text-left font-mono text-xs">
                <thead>
                  <tr className="text-text-muted">
                    <th className="pb-2">DATE</th>
                    <th className="pb-2">SCORE</th>
                    <th className="pb-2">DURATION</th>
                    <th className="pb-2">RESULT</th>
                  </tr>
                </thead>
                <tbody className="divide-y divide-border/50">
                  {historyList.map((attempt) => (
                    <tr key={attempt.id} className="text-text-secondary">
                      <td className="py-2.5">
                        {new Date(attempt.createdAt).toLocaleString()}
                      </td>
                      <td className="py-2.5 font-bold">{attempt.score}%</td>
                      <td className="py-2.5">{Math.floor(attempt.durationSecs / 60)}m {attempt.durationSecs % 60}s</td>
                      <td className={`py-2.5 font-bold ${attempt.passed ? 'text-emerald-400' : 'text-red-400'}`}>
                        {attempt.passed ? 'PASSED' : 'FAILED'}
                      </td>
                    </tr>
                  ))}
                </tbody>
              </table>
            ) : (
              <p className="text-text-muted font-body text-xs">No prior attempts found for this module.</p>
            )}
          </div>
        )}
      </div>
    </div>
  );
}
