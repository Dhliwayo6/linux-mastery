import React, { useState, useRef, useEffect } from 'react';
import { useNavigate, useSearchParams, Link } from 'react-router-dom';
import { useAuthStore } from '../../store/authStore';
import { api } from '../../lib/api';
import { CpuAnimation } from '../../components/ui/CpuAnimation';

export default function VerifyOtpPage() {
  const { setAuth } = useAuthStore();
  const navigate = useNavigate();
  const [searchParams] = useSearchParams();

  const type = searchParams.get('type') || 'register';
  const email = searchParams.get('email') || '';

  const [otp, setOtp] = useState(['', '', '', '', '', '']);
  const [loading, setLoading] = useState(false);
  const [error, setError] = useState(null);
  const [success, setSuccess] = useState(false);
  const [cooldown, setCooldown] = useState(60); // 60s cooldown for resend
  const [resendLoading, setResendLoading] = useState(false);
  const [resendMessage, setResendMessage] = useState(null);

  const inputRefs = useRef([]);

  useEffect(() => {
    if (!email) {
      navigate('/auth/login');
      return;
    }
    // Set initial focus
    if (inputRefs.current[0]) {
      inputRefs.current[0].focus();
    }
  }, [email, navigate]);

  useEffect(() => {
    let timer;
    if (cooldown > 0) {
      timer = setTimeout(() => setCooldown(cooldown - 1), 1000);
    }
    return () => clearTimeout(timer);
  }, [cooldown]);

  const handleChange = (element, index) => {
    const value = element.value;
    // Only allow numbers
    if (value && isNaN(Number(value))) return;

    const newOtp = [...otp];
    newOtp[index] = value.substring(value.length - 1);
    setOtp(newOtp);

    // Auto-focus next input
    if (value && index < 5) {
      inputRefs.current[index + 1].focus();
    }
  };

  const handleKeyDown = (e, index) => {
    if (e.key === 'Backspace') {
      if (!otp[index] && index > 0) {
        const newOtp = [...otp];
        newOtp[index - 1] = '';
        setOtp(newOtp);
        inputRefs.current[index - 1].focus();
      }
    }
  };

  const handlePaste = (e) => {
    e.preventDefault();
    const pasteData = e.clipboardData.getData('text').trim();
    if (pasteData.length === 6 && /^\d+$/.test(pasteData)) {
      const newOtp = pasteData.split('');
      setOtp(newOtp);
      if (inputRefs.current[5]) {
        inputRefs.current[5].focus();
      }
    }
  };

  const handleResend = async () => {
    if (cooldown > 0 || resendLoading) return;

    setResendLoading(true);
    setResendMessage(null);
    setError(null);

    try {
      if (type === 'register') {
        await api.post('/auth/resend-registration-otp', { email });
      } else {
        await api.post('/auth/forgot-password', { email });
      }
      setResendMessage('A new verification code has been dispatched.');
      setCooldown(60);
    } catch (err) {
      console.error(err);
      setError(err.response?.data?.error || 'Failed to resend code');
    } finally {
      setResendLoading(false);
    }
  };

  const handleSubmit = async (e) => {
    e.preventDefault();
    const otpCode = otp.join('');
    if (otpCode.length < 6) {
      setError('Please enter the full 6-digit code');
      return;
    }

    setLoading(true);
    setError(null);
    setResendMessage(null);

    try {
      if (type === 'register') {
        const { data } = await api.post('/auth/verify-registration', {
          email,
          otp: otpCode,
        });
        const { accessToken, email: userEmail, displayName } = data.data;
        setAuth({ email: userEmail, displayName }, accessToken);
        setSuccess(true);
        setTimeout(() => {
          navigate('/dashboard');
        }, 1000);
      } else {
        const { data } = await api.post('/auth/verify-reset-otp', {
          email,
          otp: otpCode,
        });
        const resetToken = data.data.resetToken;
        setSuccess(true);
        setTimeout(() => {
          navigate(`/auth/reset-password?token=${encodeURIComponent(resetToken)}`);
        }, 1000);
      }
    } catch (err) {
      console.error(err);
      setError(err.response?.data?.error || 'Verification failed');
    } finally {
      setLoading(false);
    }
  };

  return (
    <div className="min-h-screen bg-bg-base text-text-primary font-mono flex flex-col items-center justify-center p-6 select-none">
      <div className="w-full max-w-md">
        {/* Cpu Animation Header */}
        <div className="w-60 md:w-80 mx-auto text-white mb-8">
          <CpuAnimation text="VERIFY" />
        </div>

        {/* Card */}
        <div className="border border-border bg-bg-surface p-8 relative">
          <div className="absolute top-0 left-0 w-2.5 h-2.5 border-t border-l border-text-secondary"></div>
          <div className="absolute top-0 right-0 w-2.5 h-2.5 border-t border-r border-text-secondary"></div>
          <div className="absolute bottom-0 left-0 w-2.5 h-2.5 border-b border-l border-text-secondary"></div>
          <div className="absolute bottom-0 right-0 w-2.5 h-2.5 border-b border-r border-text-secondary"></div>

          <h2 className="text-sm font-bold uppercase tracking-wider mb-2 border-b border-border pb-2 text-text-secondary">
            {type === 'register' ? 'Verify System Account' : 'Verify Recovery Code'}
          </h2>

          <p className="text-xs text-text-secondary mb-6 leading-relaxed">
            We have transmitted a 6-digit OTP code to <span className="text-text-primary font-bold">{email}</span>. Input the credentials below to establish authorization.
          </p>

          {error && (
            <div className="bg-white text-black p-3 font-mono text-xs uppercase mb-6 tracking-wide leading-relaxed">
              [SYSTEM ERROR] {error}
            </div>
          )}

          {success && (
            <div className="bg-text-primary text-bg-base p-3 font-mono text-xs uppercase mb-6 tracking-wide leading-relaxed font-bold">
              [SYSTEM SUCCESS] VERIFIED. ESTABLISHING SESSION...
            </div>
          )}

          {resendMessage && (
            <div className="border border-text-primary text-text-primary p-3 font-mono text-xs uppercase mb-6 tracking-wide leading-relaxed">
              [SYSTEM INFO] {resendMessage}
            </div>
          )}

          <form onSubmit={handleSubmit} className="space-y-6">
            <div className="flex justify-between gap-2" onPaste={handlePaste}>
              {otp.map((digit, idx) => (
                <input
                  key={idx}
                  type="text"
                  maxLength="1"
                  value={digit}
                  ref={(el) => (inputRefs.current[idx] = el)}
                  onChange={(e) => handleChange(e.target, idx)}
                  onKeyDown={(e) => handleKeyDown(e, idx)}
                  disabled={loading || success}
                  className="w-12 h-12 bg-bg-base border border-border text-center text-lg font-bold text-text-primary focus:outline-none focus:border-text-primary transition-colors duration-150 rounded-none font-mono disabled:opacity-50"
                />
              ))}
            </div>

            <button
              type="submit"
              disabled={loading || success || otp.join('').length < 6}
              className="w-full py-3 bg-text-primary text-bg-base font-bold border border-text-primary hover:bg-bg-base hover:text-text-primary transition-all duration-150 uppercase text-xs tracking-wider disabled:opacity-50 disabled:cursor-not-allowed"
            >
              {loading ? 'Processing...' : 'Verify Access Code'}
            </button>
          </form>

          <div className="mt-6 flex flex-col items-center justify-between text-xs text-text-secondary gap-3">
            <button
              onClick={handleResend}
              disabled={cooldown > 0 || resendLoading || success}
              className="text-text-primary hover:underline underline-offset-4 disabled:opacity-50 disabled:no-underline disabled:cursor-not-allowed"
            >
              {cooldown > 0 ? `[Resend Code in ${cooldown}s]` : '[Resend Code]'}
            </button>
            <Link to="/auth/login" className="hover:text-text-primary hover:underline underline-offset-4">
              [Cancel & Return]
            </Link>
          </div>
        </div>
      </div>
    </div>
  );
}
