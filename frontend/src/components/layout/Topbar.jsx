import React, { useState, useRef, useEffect } from 'react';
import { useNavigate, useParams, Link } from 'react-router-dom';
import { useAuthStore } from '../../store/authStore';
import { api } from '../../lib/api';

export default function Topbar({ onToggleSidebar }) {
  const { user, clearAuth } = useAuthStore();
  const navigate = useNavigate();
  const { moduleId, sectionId } = useParams();
  const [dropdownOpen, setDropdownOpen] = useState(false);
  const dropdownRef = useRef(null);

  useEffect(() => {
    function handleClickOutside(event) {
      if (dropdownRef.current && !dropdownRef.current.contains(event.target)) {
        setDropdownOpen(false);
      }
    }
    document.addEventListener('mousedown', handleClickOutside);
    return () => document.removeEventListener('mousedown', handleClickOutside);
  }, []);

  const handleLogout = async () => {
    try {
      await api.post('/api/v1/auth/logout');
    } catch (err) {
      console.error('Logout error', err);
    } finally {
      clearAuth();
      navigate('/auth/login');
    }
  };

  return (
    <header className="h-14 border-b border-border bg-bg-base flex items-center justify-between px-4 z-40 select-none">
      {/* Left section: Hamburger + Logo */}
      <div className="flex items-center gap-3">
        <button
          onClick={onToggleSidebar}
          className="lg:hidden p-1 border border-border text-text-primary hover:bg-bg-elevated focus:outline-none"
          title="Toggle Navigation"
        >
          <svg className="w-5 h-5" fill="none" viewBox="0 0 24 24" stroke="currentColor">
            <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={2} d="M4 6h16M4 12h16M4 18h16" />
          </svg>
        </button>
        <Link to="/dashboard" className="font-display font-bold text-white tracking-widest text-sm hover:opacity-80 transition-opacity">
          LINUX-MASTERY
        </Link>
      </div>

      {/* Middle section: Breadcrumb */}
      <div className="hidden md:flex items-center gap-2 text-xs text-text-secondary font-mono">
        <Link to="/dashboard" className="hover:text-text-primary">root</Link>
        {moduleId && (
          <>
            <span>/</span>
            <Link to={`/modules/${moduleId}`} className="hover:text-text-primary">{moduleId}</Link>
          </>
        )}
        {sectionId && (
          <>
            <span>/</span>
            <span className="text-text-primary">{sectionId}</span>
          </>
        )}
      </div>

      {/* Right section: User Menu */}
      <div className="relative font-mono" ref={dropdownRef}>
        <button
          onClick={() => setDropdownOpen((prev) => !prev)}
          className="px-3 py-1.5 border border-border text-xs text-text-primary hover:border-text-primary flex items-center gap-2 transition-colors duration-150"
        >
          <span className="hidden md:inline">{user?.displayName || user?.email || 'STUDENT'}</span>
          <span className="inline md:hidden">
            <svg className="w-4 h-4" fill="none" viewBox="0 0 24 24" stroke="currentColor">
              <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={2} d="M16 7a4 4 0 11-8 0 4 4 0 018 0zM12 14a7 7 0 00-7 7h14a7 7 0 00-7-7z" />
            </svg>
          </span>
          <svg
            className={`w-3.5 h-3.5 transition-transform duration-150 ${dropdownOpen ? 'rotate-180' : ''}`}
            fill="none"
            viewBox="0 0 24 24"
            stroke="currentColor"
          >
            <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={2} d="M19 9l-7 7-7-7" />
          </svg>
        </button>

        {dropdownOpen && (
          <div className="absolute right-0 mt-1 w-44 bg-bg-surface border border-border shadow-2xl py-1 text-xs z-50">
            <Link
              to="/dashboard"
              onClick={() => setDropdownOpen(false)}
              className="block px-4 py-2 text-text-secondary hover:text-text-primary hover:bg-bg-elevated transition-colors"
            >
              [Dashboard]
            </Link>
            <Link
              to="/profile"
              onClick={() => setDropdownOpen(false)}
              className="block px-4 py-2 text-text-secondary hover:text-text-primary hover:bg-bg-elevated transition-colors"
            >
              [User Profile]
            </Link>
            {user?.role === 'ADMIN' && (
              <Link
                to="/admin"
                onClick={() => setDropdownOpen(false)}
                className="block px-4 py-2 text-text-secondary hover:text-text-primary hover:bg-bg-elevated transition-colors"
              >
                [Admin Console]
              </Link>
            )}
            <button
              onClick={handleLogout}
              className="w-full text-left block px-4 py-2 text-text-secondary hover:text-text-primary hover:bg-bg-elevated transition-colors border-t border-border mt-1 pt-2"
            >
              [Logout]
            </button>
          </div>
        )}
      </div>
    </header>
  );
}
