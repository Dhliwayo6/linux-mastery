import React, { useState, useEffect } from 'react';
import { useNavigate, useSearchParams, Link } from 'react-router-dom';
import { api } from '../../lib/api';
import PasswordInput from '../../components/ui/PasswordInput';
import { CpuAnimation } from '../../components/ui/CpuAnimation';

export default function ResetPasswordPage() {
  const navigate = useNavigate();
  const [searchParams] = useSearchParams();
  const token = searchParams.get('token') || '';

  const [password, setPassword] = useState('');
  const [confirmPassword, setConfirmPassword] = useState('');
  const [loading, setLoading] = useState(false);
  const [error, setError] = useState(null);
  const [success, setSuccess] = useState(false);
  const [passwordError, setPasswordError] = useState(null);
  const [confirmPasswordError, setConfirmPasswordError] = useState(null);

  useEffect(() => {
    if (!token) {
      navigate('/auth/login');
    }
  }, [token, navigate]);

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
    if (!password || !confirmPassword) {
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
      await api.post('/auth/reset-password', {
        token,
        newPassword: password,
      });
      setSuccess(true);
      setTimeout(() => {
        navigate('/auth/login');
      }, 1500);
    } catch (err) {
      console.error(err);
      const errMsg = err.response?.data?.error || 'Failed to reset password';
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
          <CpuAnimation text="UPDATE" />
        </div>

        {/* Card */}
        <div className="border border-border bg-bg-surface p-8 relative">
          <div className="absolute top-0 left-0 w-2.5 h-2.5 border-t border-l border-text-secondary"></div>
          <div className="absolute top-0 right-0 w-2.5 h-2.5 border-t border-r border-text-secondary"></div>
          <div className="absolute bottom-0 left-0 w-2.5 h-2.5 border-b border-l border-text-secondary"></div>
          <div className="absolute bottom-0 right-0 w-2.5 h-2.5 border-b border-r border-text-secondary"></div>

          <h2 className="text-sm font-bold uppercase tracking-wider mb-6 border-b border-border pb-2 text-text-secondary">
            Establish New Password
          </h2>

          {error && (
            <div className="bg-white text-black p-3 font-mono text-xs uppercase mb-6 tracking-wide leading-relaxed">
              [SYSTEM ERROR] {error}
            </div>
          )}

          {success && (
            <div className="bg-text-primary text-bg-base p-3 font-mono text-xs uppercase mb-6 tracking-wide leading-relaxed font-bold">
              [SYSTEM SUCCESS] PASSWORD UPDATED. REDIRECTING TO LOGIN...
            </div>
          )}

          <form onSubmit={handleSubmit} className="space-y-6">
            <PasswordInput
              id="password"
              name="password"
              value={password}
              onChange={handlePasswordChange}
              autoComplete="new-password"
              label="New Password"
              error={passwordError}
              required
              disabled={success}
            />

            <PasswordInput
              id="confirmPassword"
              name="confirmPassword"
              value={confirmPassword}
              onChange={handleConfirmPasswordChange}
              autoComplete="new-password"
              label="Confirm New Password"
              error={confirmPasswordError}
              required
              disabled={success}
            />

            <button
              type="submit"
              disabled={loading || success}
              className="w-full py-3 bg-text-primary text-bg-base font-bold border border-text-primary hover:bg-bg-base hover:text-text-primary transition-all duration-150 uppercase text-xs tracking-wider disabled:opacity-50 disabled:cursor-not-allowed"
            >
              {loading ? 'Processing...' : 'Apply New Credentials'}
            </button>
          </form>

          <div className="mt-6 text-center text-xs text-text-secondary">
            <Link to="/auth/login" className="text-text-primary hover:underline underline-offset-4">
              [Return to Login]
            </Link>
          </div>
        </div>
      </div>
    </div>
  );
}
