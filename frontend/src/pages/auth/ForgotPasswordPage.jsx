import React, { useState } from 'react';
import { useNavigate, Link, Navigate } from 'react-router-dom';
import { useAuthStore } from '../../store/authStore';
import { api } from '../../lib/api';
import { CpuAnimation } from '../../components/ui/CpuAnimation';

export default function ForgotPasswordPage() {
  const { user } = useAuthStore();
  const navigate = useNavigate();

  const [email, setEmail] = useState('');
  const [loading, setLoading] = useState(false);
  const [error, setError] = useState(null);
  const [success, setSuccess] = useState(false);

  // If already logged in, redirect to dashboard
  if (user) {
    return <Navigate to="/dashboard" replace />;
  }

  const handleSubmit = async (e) => {
    e.preventDefault();
    if (!email) {
      setError('Email is required');
      return;
    }

    setLoading(true);
    setError(null);

    try {
      await api.post('/auth/forgot-password', { email });
      setSuccess(true);
      // Wait briefly or navigate directly to the OTP verification screen
      setTimeout(() => {
        navigate(`/auth/verify-otp?type=reset&email=${encodeURIComponent(email)}`);
      }, 1500);
    } catch (err) {
      console.error(err);
      const errMsg = err.response?.data?.error || 'Failed to request reset code';
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
          <CpuAnimation text="RECOVERY" />
        </div>

        {/* Card */}
        <div className="border border-border bg-bg-surface p-8 relative">
          <div className="absolute top-0 left-0 w-2.5 h-2.5 border-t border-l border-text-secondary"></div>
          <div className="absolute top-0 right-0 w-2.5 h-2.5 border-t border-r border-text-secondary"></div>
          <div className="absolute bottom-0 left-0 w-2.5 h-2.5 border-b border-l border-text-secondary"></div>
          <div className="absolute bottom-0 right-0 w-2.5 h-2.5 border-b border-r border-text-secondary"></div>

          <h2 className="text-sm font-bold uppercase tracking-wider mb-6 border-b border-border pb-2 text-text-secondary">
            Reset Password Request
          </h2>

          {error && (
            <div className="bg-white text-black p-3 font-mono text-xs uppercase mb-6 tracking-wide leading-relaxed">
              [SYSTEM ERROR] {error}
            </div>
          )}

          {success && (
            <div className="bg-text-primary text-bg-base p-3 font-mono text-xs uppercase mb-6 tracking-wide leading-relaxed font-bold">
              [SYSTEM SUCCESS] RESET OTP DISPATCHED. REDIRECTING...
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
                disabled={success}
                className="w-full bg-bg-base border border-border px-3 py-2 text-sm text-text-primary focus:outline-none focus:border-text-primary transition-colors duration-150 rounded-none font-mono disabled:opacity-50"
                placeholder="operator@system.io"
              />
            </div>

            <button
              type="submit"
              disabled={loading || success}
              className="w-full py-3 bg-text-primary text-bg-base font-bold border border-text-primary hover:bg-bg-base hover:text-text-primary transition-all duration-150 uppercase text-xs tracking-wider disabled:opacity-50 disabled:cursor-not-allowed"
            >
              {loading ? 'Processing...' : 'Send Recovery OTP'}
            </button>
          </form>

          <div className="mt-6 text-center text-xs text-text-secondary">
            <span>Remember password? </span>
            <Link to="/auth/login" className="text-text-primary hover:underline underline-offset-4">
              [Log In]
            </Link>
          </div>
        </div>
      </div>
    </div>
  );
}
