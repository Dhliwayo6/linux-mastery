import React from 'react';

export default function QuizQuestion({ question, selectedValue, onChange, submitted, feedback }) {
  const { questionText, questionType, options } = question;

  const handleOptionChange = (val) => {
    if (submitted) return;
    onChange(val);
  };

  const renderOptions = () => {
    if (questionType === 'MULTIPLE_CHOICE') {
      return (
        <div className="grid grid-cols-1 gap-3">
          {options?.map((option) => {
            const isSelected = selectedValue === option.id;
            return (
              <label
                key={option.id}
                className={`flex items-start gap-3 p-4 border rounded cursor-pointer transition-all ${
                  isSelected
                    ? 'border-text-primary bg-bg-elevated'
                    : 'border-border hover:border-text-secondary bg-bg-surface'
                } ${submitted ? 'cursor-not-allowed opacity-90' : ''}`}
              >
                <input
                  type="radio"
                  name={`question-${question.id}`}
                  value={option.id}
                  checked={isSelected}
                  disabled={submitted}
                  onChange={() => handleOptionChange(option.id)}
                  className="mt-1 accent-text-primary"
                />
                <span className="font-body text-sm text-text-primary">
                  {option.text}
                </span>
              </label>
            );
          })}
        </div>
      );
    }

    if (questionType === 'TRUE_FALSE') {
      const tfOptions = [
        { id: 'true', text: 'True' },
        { id: 'false', text: 'False' },
      ];
      return (
        <div className="grid grid-cols-1 md:grid-cols-2 gap-4">
          {tfOptions.map((option) => {
            const isSelected = selectedValue === option.id;
            return (
              <button
                type="button"
                key={option.id}
                disabled={submitted}
                onClick={() => handleOptionChange(option.id)}
                className={`p-4 border rounded font-display text-sm font-bold uppercase transition-all cursor-pointer ${
                  isSelected
                    ? 'border-text-primary bg-bg-elevated text-text-primary'
                    : 'border-border hover:border-text-secondary bg-bg-surface text-text-secondary'
                } ${submitted ? 'cursor-not-allowed opacity-80' : ''}`}
              >
                {option.text}
              </button>
            );
          })}
        </div>
      );
    }

    if (questionType === 'FILL_IN_BLANK') {
      return (
        <div className="space-y-1">
          <input
            type="text"
            disabled={submitted}
            value={selectedValue || ''}
            onChange={(e) => handleOptionChange(e.target.value)}
            placeholder="Type your answer here..."
            className="w-full bg-black text-text-primary border border-border p-3 rounded font-mono text-sm focus:border-text-primary outline-none disabled:opacity-80 disabled:cursor-not-allowed"
          />
        </div>
      );
    }

    return null;
  };

  return (
    <div className="space-y-4 border border-border p-6 rounded-lg bg-bg-surface/50">
      <div className="flex items-start gap-3">
        <span className="font-mono text-xs text-text-muted mt-0.5">
          [Q]
        </span>
        <h4 className="font-display font-bold text-sm text-text-primary leading-relaxed">
          {questionText}
        </h4>
      </div>

      {renderOptions()}

      {/* Render Feedback if submitted */}
      {submitted && feedback && (
        <div
          className={`p-4 border rounded font-body text-xs space-y-2 mt-4 ${
            feedback.correct
              ? 'border-emerald-500/30 bg-emerald-950/10 text-emerald-400'
              : 'border-red-500/30 bg-red-950/10 text-red-400'
          }`}
        >
          <div className="flex items-center gap-2 font-bold uppercase">
            <span>{feedback.correct ? '[✓] Correct' : '[✗] Incorrect'}</span>
          </div>
          <div>
            <span className="text-text-muted">Explanation: </span>
            <span className="text-text-secondary">{feedback.explanation}</span>
          </div>
          {!feedback.correct && (
            <div className="text-[11px]">
              <span className="text-text-muted">Correct answer: </span>
              <span className="font-mono font-bold">{feedback.correctAnswer}</span>
            </div>
          )}
        </div>
      )}
    </div>
  );
}
