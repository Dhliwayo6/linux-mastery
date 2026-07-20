import React, { useState } from 'react';
import { useNavigate, Link, Navigate } from 'react-router-dom';
import { useAuthStore } from '../../store/authStore';
import { api } from '../../lib/api';
import PasswordInput from '../../components/ui/PasswordInput';
import { CpuAnimation } from '../../components/ui/CpuAnimation';

export default function RegisterPage() {
  const { user, setAuth } = useAuthStore();
  const navigate = useNavigate();

  const [email, setEmail] = useState('');
  const [displayName, setDisplayName] = useState('');
  const [password, setPassword] = useState('');
  const [confirmPassword, setConfirmPassword] = useState('');
  const [loading, setLoading] = useState(false);
  const [error, setError] = useState(null);
  const [passwordError, setPasswordError] = useState(null);
  const [confirmPasswordError, setConfirmPasswordError] = useState(null);

  // If already logged in, redirect to dashboard
  if (user) {
    return <Navigate to="/dashboard" replace />;
  }

  const handlePasswordChange = (e) => {
    setPassword(e.target.value);
    setPasswordError(null);
    setConfirmPasswordError(null);
  };

  const handleConfirmPasswordChange = (e) => {
    setConfirmPassword(e.target.value);
    setPasswordError(null);
    setConfirmPasswordError(null);
  };

  const handleSubmit = async (e) => {
    e.preventDefault();
    if (!email || !password || !displayName || !confirmPassword) {
      setError('All fields are required');
      return;
    }

    setPasswordError(null);
    setConfirmPasswordError(null);

    let hasValidationError = false;

    if (password.length < 8) {
      setPasswordError('Password must be at least 8 characters');
      hasValidationError = true;
    }

    if (password !== confirmPassword) {
      setConfirmPasswordError('Passwords do not match');
      hasValidationError = true;
    }

    if (hasValidationError) {
      return;
    }

    setLoading(true);
    setError(null);

    try {
      await api.post('/auth/register', {
        email,
        password,
        displayName,
      });
      navigate(`/auth/verify-otp?type=register&email=${encodeURIComponent(email)}`);
    } catch (err) {
      console.error(err);
      const errMsg = err.response?.data?.error || 'Registration failed';
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
          <CpuAnimation text="SIGN UP" />
        </div>

        {/* Card */}
        <div className="border border-border bg-bg-surface p-8 relative">
          <div className="absolute top-0 left-0 w-2.5 h-2.5 border-t border-l border-text-secondary"></div>
          <div className="absolute top-0 right-0 w-2.5 h-2.5 border-t border-r border-text-secondary"></div>
          <div className="absolute bottom-0 left-0 w-2.5 h-2.5 border-b border-l border-text-secondary"></div>
          <div className="absolute bottom-0 right-0 w-2.5 h-2.5 border-b border-r border-text-secondary"></div>

          <h2 className="text-sm font-bold uppercase tracking-wider mb-6 border-b border-border pb-2 text-text-secondary">
            Create System Account
          </h2>

          {error && (
            <div className="bg-white text-black p-3 font-mono text-xs uppercase mb-6 tracking-wide leading-relaxed">
              [SYSTEM ERROR] {error}
            </div>
          )}

          <form onSubmit={handleSubmit} className="space-y-6">
            <div className="space-y-2">
              <label className="block text-xs uppercase tracking-wider text-text-secondary">
                Display Name / Handle
              </label>
              <input
                type="text"
                value={displayName}
                onChange={(e) => setDisplayName(e.target.value)}
                required
                className="w-full bg-bg-base border border-border px-3 py-2 text-sm text-text-primary focus:outline-none focus:border-text-primary transition-colors duration-150 rounded-none font-mono"
                placeholder="neo_matrix"
              />
            </div>

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
              onChange={handlePasswordChange}
              autoComplete="new-password"
              label="Password"
              error={passwordError}
              required
            />

            <PasswordInput
              id="confirmPassword"
              name="confirmPassword"
              value={confirmPassword}
              onChange={handleConfirmPasswordChange}
              autoComplete="new-password"
              label="Confirm password"
              error={confirmPasswordError}
              required
            />

            <button
              type="submit"
              disabled={loading}
              className="w-full py-3 bg-text-primary text-bg-base font-bold border border-text-primary hover:bg-bg-base hover:text-text-primary transition-all duration-150 uppercase text-xs tracking-wider disabled:opacity-50 disabled:cursor-not-allowed"
            >
              {loading ? 'Processing...' : 'Register Account'}
            </button>
          </form>

          <div className="mt-6 text-center text-xs text-text-secondary">
            <span>Already registered? </span>
            <Link to="/auth/login" className="text-text-primary hover:underline underline-offset-4">
              [Log In]
            </Link>
          </div>
        </div>
      </div>
    </div>
  );
}
