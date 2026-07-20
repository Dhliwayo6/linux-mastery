import React from 'react';

export default class ErrorBoundary extends React.Component {
  constructor(props) {
    super(props);
    this.state = { hasError: false, error: null };
  }

  static getDerivedStateFromError(error) {
    return { hasError: true, error };
  }

  componentDidCatch(error, errorInfo) {
    console.error('ErrorBoundary caught an error', error, errorInfo);
  }

  render() {
    if (this.state.hasError) {
      return (
        <div className="min-h-screen bg-bg-base text-text-primary font-mono flex flex-col items-center justify-center p-6 select-none">
          <div className="max-w-md w-full border border-border p-6 bg-bg-surface rounded-lg space-y-4">
            <h2 className="text-xl font-bold font-display text-text-primary">
              [!] SYSTEM_EXCEPTION
            </h2>
            <div className="border-b border-border" />
            <p className="text-text-secondary text-sm">
              An unexpected UI rendering exception has occurred.
            </p>
            {this.state.error && (
              <pre className="bg-bg-elevated p-3 text-xs text-text-muted rounded border border-border overflow-x-auto">
                {this.state.error.toString()}
              </pre>
            )}
            <button
              onClick={() => window.location.reload()}
              className="w-full bg-text-primary text-bg-base font-bold py-2 rounded text-sm hover:opacity-90 transition-opacity cursor-pointer text-center"
            >
              REBOOT SYSTEM
            </button>
          </div>
        </div>
      );
    }

    return this.props.children;
  }
}
