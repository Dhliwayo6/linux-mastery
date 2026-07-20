import React, { useState } from 'react';
import { useMutation, useQueryClient } from '@tanstack/react-query';
import { Link } from 'react-router-dom';
import api from '../../lib/api';
import { useToastStore } from '../../store/toastStore';
import QuizQuestion from './QuizQuestion';

export default function QuizSection({ questions, sectionId, nextSectionUrl, onPassed }) {
  const queryClient = useQueryClient();
  const addToast = useToastStore((state) => state.addToast);

  const [answers, setAnswers] = useState({});
  const [submitted, setSubmitted] = useState(false);
  const [result, setResult] = useState(null);

  const allAnswered = questions?.length > 0 && questions.every((q) => {
    const val = answers[q.id];
    return val !== undefined && val !== null && String(val).trim() !== '';
  });

  const submitMutation = useMutation({
    mutationFn: async (payload) => {
      const res = await api.post(`/quiz/${sectionId}/submit`, payload);
      return res.data.data;
    },
    onSuccess: (data) => {
      setResult(data);
      setSubmitted(true);
      
      if (data.passed) {
        addToast('success', 'Section complete! ✓');
        // Invalidate queries to refresh sidebar and parent completion states
        queryClient.invalidateQueries({ queryKey: ['progress'] });
        queryClient.invalidateQueries({ queryKey: ['module'] });
        if (onPassed) onPassed();
      } else {
        addToast('warning', `Score: ${data.score}%. Try again.`);
      }
    },
    onError: (err) => {
      console.error(err);
      addToast('error', 'Something went wrong. Please try again.');
    },
  });

  const handleValueChange = (questionId, value) => {
    setAnswers((prev) => ({
      ...prev,
      [questionId]: value,
    }));
  };

  const handleSubmit = (e) => {
    e.preventDefault();
    if (!allAnswered || submitMutation.isPending) return;

    const payload = {
      answers: Object.entries(answers).map(([questionId, selectedAnswer]) => ({
        questionId,
        selectedAnswer,
      })),
    };

    submitMutation.mutate(payload);
  };

  const handleReset = () => {
    setSubmitted(false);
    setResult(null);
  };

  return (
    <form onSubmit={handleSubmit} className="space-y-6 border-t border-border pt-8 mt-8 select-none">
      <div className="space-y-2">
        <h3 className="font-display font-bold text-base text-text-primary uppercase tracking-wider">
          Section Quiz
        </h3>
        <p className="text-text-secondary text-xs font-body">
          Pass this quiz with at least 60% to mark the section as complete and unlock the next lesson.
        </p>
      </div>

      <div className="space-y-6">
        {questions?.map((q) => (
          <QuizQuestion
            key={q.id}
            question={q}
            selectedValue={answers[q.id]}
            onChange={(val) => handleValueChange(q.id, val)}
            submitted={submitted}
            feedback={result?.feedback?.find((f) => f.questionId === q.id)}
          />
        ))}
      </div>

      {/* Action buttons / Result banners */}
      <div className="space-y-4 pt-4">
        {submitMutation.isError && (
          <div className="border border-red-500/30 bg-red-950/15 p-4 rounded text-xs text-red-400 font-mono">
            [✗] ERROR: Failed to submit answers. Please check your connection.
          </div>
        )}

        {submitted && result && (
          <div
            className={`border p-6 rounded-lg font-mono text-sm space-y-4 ${
              result.passed
                ? 'border-emerald-500/30 bg-emerald-950/10 text-emerald-400'
                : 'border-amber-500/30 bg-amber-950/10 text-amber-400'
            }`}
          >
            <div className="font-display font-bold text-base uppercase">
              {result.passed ? '[✓] SECTION COMPLETE' : '[!] QUIZ FAILED'}
            </div>
            <div className="font-body text-xs text-text-secondary">
              Your Score: <span className="font-bold text-text-primary">{result.score}%</span> (Required: 60%)
            </div>

            <div className="flex gap-4 pt-2">
              {!result.passed && (
                <button
                  type="button"
                  onClick={handleReset}
                  className="bg-text-primary text-black font-bold px-4 py-2 rounded text-xs hover:opacity-90 cursor-pointer"
                >
                  TRY AGAIN
                </button>
              )}

              {result.passed && nextSectionUrl && (
                <Link
                  to={nextSectionUrl}
                  className="bg-emerald-500 text-black font-bold px-4 py-2 rounded text-xs hover:bg-emerald-400 transition-colors cursor-pointer text-center"
                >
                  NEXT SECTION →
                </Link>
              )}

              {result.passed && !nextSectionUrl && (
                <Link
                  to={`/modules/${questions?.[0]?.section?.moduleId || ''}`}
                  className="bg-text-primary text-black font-bold px-4 py-2 rounded text-xs hover:opacity-90 cursor-pointer text-center"
                >
                  MODULE OVERVIEW
                </Link>
              )}
            </div>
          </div>
        )}

        {!submitted && (
          <button
            type="submit"
            disabled={!allAnswered || submitMutation.isPending}
            className={`w-full font-bold py-3 rounded text-sm transition-all select-none ${
              allAnswered && !submitMutation.isPending
                ? 'bg-text-primary text-black cursor-pointer hover:opacity-95'
                : 'bg-bg-elevated border border-border text-text-muted cursor-not-allowed'
            }`}
          >
            {submitMutation.isPending ? 'GRADING ANSWERS...' : 'SUBMIT QUIZ'}
          </button>
        )}
      </div>
    </form>
  );
}
