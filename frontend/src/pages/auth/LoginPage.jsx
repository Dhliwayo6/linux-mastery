import React, { useState } from 'react';
import { useNavigate, Link, Navigate } from 'react-router-dom';
import { useAuthStore } from '../../store/authStore';
import { api } from '../../lib/api';
import PasswordInput from '../../components/ui/PasswordInput';
import { CpuAnimation } from '../../components/ui/CpuAnimation';

export default function LoginPage() {
  const { user, setAuth } = useAuthStore();
  const navigate = useNavigate();

  const [email, setEmail] = useState('');
  const [password, setPassword] = useState('');
  const [loading, setLoading] = useState(false);
  const [error, setError] = useState(null);

  // If already logged in, redirect to dashboard
  if (user) {
    return <Navigate to="/dashboard" replace />;
  }

  const handleSubmit = async (e) => {
    e.preventDefault();
    if (!email || !password) {
      setError('Email and password are required');
      return;
    }

    setLoading(true);
    setError(null);

    try {
      const { data } = await api.post('/auth/login', { email, password });
      const { accessToken, email: userEmail, displayName } = data.data;
      setAuth({ email: userEmail, displayName }, accessToken);
      navigate('/dashboard');
    } catch (err) {
      console.error(err);
      const errMsg = err.response?.data?.error || 'Authentication failed';
      setError(errMsg);
    } finally {
      setLoading(false);
    }
  };

  return (
    <div className="min-h-screen bg-bg-base text-text-primary font-mono flex flex-col items-center justify-center p-6 select-none">
      <div className="w-full max-w-md">
        {/* Cpu Animation Header */}
        <div className="w-60 md:w-80 mx-auto text-white mb-8">
          <CpuAnimation text="LOG IN" />
        </div>

        {/* Card */}
        <div className="border border-border bg-bg-surface p-8 relative">
          <div className="absolute top-0 left-0 w-2.5 h-2.5 border-t border-l border-text-secondary"></div>
          <div className="absolute top-0 right-0 w-2.5 h-2.5 border-t border-r border-text-secondary"></div>
          <div className="absolute bottom-0 left-0 w-2.5 h-2.5 border-b border-l border-text-secondary"></div>
          <div className="absolute bottom-0 right-0 w-2.5 h-2.5 border-b border-r border-text-secondary"></div>

          <h2 className="text-sm font-bold uppercase tracking-wider mb-6 border-b border-border pb-2 text-text-secondary">
            User Authentication
          </h2>

          {error && (
            <div className="bg-white text-black p-3 font-mono text-xs uppercase mb-6 tracking-wide leading-relaxed">
              [SYSTEM ERROR] {error}
            </div>
          )}

          <form onSubmit={handleSubmit} className="space-y-6">
            <div className="space-y-2">
              <label className="block text-xs uppercase tracking-wider text-text-secondary">
                Email Address
              </label>
              <input
                type="email"
                value={email}
                onChange={(e) => setEmail(e.target.value)}
                required
                className="w-full bg-bg-base border border-border px-3 py-2 text-sm text-text-primary focus:outline-none focus:border-text-primary transition-colors duration-150 rounded-none font-mono"
                placeholder="operator@system.io"
              />
            </div>

            <PasswordInput
              id="password"
              name="password"
              value={password}
              onChange={(e) => setPassword(e.target.value)}
              autoComplete="current-password"
              label="Password"
              placeholder="••••••••"
              required
            />

            <button
              type="submit"
              disabled={loading}
              className="w-full py-3 bg-text-primary text-bg-base font-bold border border-text-primary hover:bg-bg-base hover:text-text-primary transition-all duration-150 uppercase text-xs tracking-wider disabled:opacity-50 disabled:cursor-not-allowed"
            >
              {loading ? 'Processing...' : 'Establish Session'}
            </button>
          </form>

          <div className="mt-6 flex items-center justify-between text-xs text-text-secondary">
            <Link to="/auth/forgot-password" className="hover:text-text-primary hover:underline underline-offset-4">
              [Forgot Password?]
            </Link>
            <div>
              <span>No credentials? </span>
              <Link to="/auth/register" className="text-text-primary hover:underline underline-offset-4">
                [Create Account]
              </Link>
            </div>
          </div>
        </div>
      </div>
    </div>
  );
}
