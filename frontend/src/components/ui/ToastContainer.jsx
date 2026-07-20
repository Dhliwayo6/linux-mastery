import React from 'react';
import { useToastStore } from '../../store/toastStore';

export default function ToastContainer() {
  const { toasts, removeToast } = useToastStore();

  const getGlyph = (type) => {
    switch (type) {
      case 'success':
        return '[✓]';
      case 'warning':
        return '[!]';
      case 'error':
        return '[✗]';
      case 'info':
      default:
        return '[i]';
    }
  };

  return (
    <div className="fixed top-4 left-4 right-4 md:left-auto md:right-6 md:top-6 z-50 flex flex-col gap-3 w-auto md:w-full md:max-w-sm pointer-events-none">
      {toasts.map((toast) => (
        <div
          key={toast.id}
          className="pointer-events-auto flex items-start gap-3 bg-bg-surface border border-border-trace p-4 rounded shadow-2xl animate-fade-in font-body text-sm"
          role="alert"
        >
          <span className="font-display font-bold text-text-primary select-none">
            {getGlyph(toast.type)}
          </span>
          <div className="flex-1 text-text-primary whitespace-pre-line">
            {toast.message}
          </div>
          <button
            onClick={() => removeToast(toast.id)}
            className="text-text-muted hover:text-text-primary font-display ml-2 cursor-pointer transition-colors"
            aria-label="Close"
          >
            ×
          </button>
        </div>
      ))}
    </div>
  );
}
