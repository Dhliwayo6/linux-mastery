import React, { useState, useEffect } from 'react';
import { useAuthStore } from '../store/authStore';
import { useToastStore } from '../store/toastStore';
import { api } from '../lib/api';

export default function ProfilePage() {
  const { user, updateUser } = useAuthStore();
  const { addToast } = useToastStore();

  const [displayName, setDisplayName] = useState(user?.displayName || '');
  const [email, setEmail] = useState(user?.email || '');
  const [loading, setLoading] = useState(false);
  const [error, setError] = useState(null);

  useEffect(() => {
    if (user) {
      setDisplayName(user.displayName || '');
      setEmail(user.email || '');
    }
  }, [user]);

  const handleSubmit = async (e) => {
    e.preventDefault();
    if (!displayName || !email) {
      setError('Display name and email are required');
      return;
    }

    setLoading(true);
    setError(null);

    try {
      const { data } = await api.put('/api/v1/users/me', {
        displayName,
        email,
      });

      // Update local store state
      updateUser({
        displayName: data.data.displayName,
        email: data.data.email,
      });

      addToast('success', 'User profile successfully synchronized.');
    } catch (err) {
      console.error(err);
      const errMsg = err.response?.data?.error || 'Profile update failed';
      setError(errMsg);
      addToast('error', errMsg);
    } finally {
      setLoading(false);
    }
  };

  return (
    <div className="p-6 max-w-2xl mx-auto space-y-8 animate-fade-in font-mono">
      {/* Header Panel */}
      <div className="border border-border p-6 bg-bg-surface rounded-lg relative">
        <div className="absolute top-0 left-0 w-2 h-2 border-t-2 border-l-2 border-text-secondary"></div>
        <div className="absolute top-0 right-0 w-2 h-2 border-t-2 border-r-2 border-text-secondary"></div>
        <div className="absolute bottom-0 left-0 w-2 h-2 border-b-2 border-l-2 border-text-secondary"></div>
        <div className="absolute bottom-0 right-0 w-2 h-2 border-b-2 border-r-2 border-text-secondary"></div>

        <h2 className="text-xl font-bold font-display uppercase tracking-wider text-text-primary mb-2">
          Operator Profile Settings
        </h2>
        <p className="text-text-secondary text-xs">
          Synchronize user credentials and profile details below.
        </p>
      </div>

      {/* Profile Form Card */}
      <div className="border border-border bg-bg-surface p-6 rounded-lg relative">
        <div className="absolute top-0 left-0 w-2.5 h-2.5 border-t border-l border-text-secondary"></div>
        <div className="absolute top-0 right-0 w-2.5 h-2.5 border-t border-r border-text-secondary"></div>
        <div className="absolute bottom-0 left-0 w-2.5 h-2.5 border-b border-l border-text-secondary"></div>
        <div className="absolute bottom-0 right-0 w-2.5 h-2.5 border-b border-r border-text-secondary"></div>

        {error && (
          <div className="bg-white text-black p-3 font-mono text-xs uppercase mb-6 tracking-wide leading-relaxed">
            [SYSTEM ERROR] {error}
          </div>
        )}

        <form onSubmit={handleSubmit} className="space-y-6">
          <div className="space-y-2">
            <label className="block text-xs uppercase tracking-wider text-text-secondary">
              SYSTEM IDENTIFIER (ID)
            </label>
            <input
              type="text"
              value={user?.id || 'UNKNOWN'}
              disabled
              className="w-full bg-bg-elevated border border-border px-3 py-2 text-sm text-text-secondary opacity-60 rounded-none cursor-not-allowed"
            />
          </div>

          <div className="space-y-2">
            <label className="block text-xs uppercase tracking-wider text-text-secondary">
              DISPLAY NAME
            </label>
            <input
              type="text"
              value={displayName}
              onChange={(e) => setDisplayName(e.target.value)}
              required
              maxLength={50}
              className="w-full bg-bg-base border border-border px-3 py-2 text-sm text-text-primary focus:outline-none focus:border-text-primary transition-colors duration-150 rounded-none"
              placeholder="e.g. Linus Torvalds"
            />
          </div>

          <div className="space-y-2">
            <label className="block text-xs uppercase tracking-wider text-text-secondary">
              EMAIL ADDRESS
            </label>
            <input
              type="email"
              value={email}
              onChange={(e) => setEmail(e.target.value)}
              required
              className="w-full bg-bg-base border border-border px-3 py-2 text-sm text-text-primary focus:outline-none focus:border-text-primary transition-colors duration-150 rounded-none"
              placeholder="operator@system.io"
            />
          </div>

          <div className="space-y-2">
            <label className="block text-xs uppercase tracking-wider text-text-secondary">
              SECURITY ROLE
            </label>
            <input
              type="text"
              value={user?.role || 'STUDENT'}
              disabled
              className="w-full bg-bg-elevated border border-border px-3 py-2 text-sm text-text-secondary opacity-60 rounded-none cursor-not-allowed"
            />
          </div>

          <button
            type="submit"
            disabled={loading}
            className="w-full py-3 bg-text-primary text-bg-base font-bold border border-text-primary hover:bg-bg-base hover:text-text-primary transition-all duration-150 uppercase text-xs tracking-wider disabled:opacity-50"
          >
            {loading ? 'Synchronizing...' : 'Save Profile Details'}
          </button>
        </form>
      </div>
    </div>
  );
}
