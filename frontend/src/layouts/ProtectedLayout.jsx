import React, { useEffect, useState } from 'react';
import { Navigate, Outlet } from 'react-router-dom';
import { useAuthStore } from '../store/authStore';
import { api } from '../lib/api';

export default function ProtectedLayout() {
  const { user, accessToken, setAccessToken, clearAuth } = useAuthStore();
  const [isRefreshing, setIsRefreshing] = useState(!accessToken);

  useEffect(() => {
    let active = true;
    const checkAuth = async () => {
      if (accessToken) {
        if (active) setIsRefreshing(false);
        return;
      }

      try {
        const { data } = await api.post('/api/v1/auth/refresh');
        if (active) {
          setAccessToken(data.data.accessToken);
        }
      } catch {
        if (active) {
          clearAuth();
        }
      } finally {
        if (active) {
          setIsRefreshing(false);
        }
      }
    };

    checkAuth();
    return () => {
      active = false;
    };
  }, [accessToken, setAccessToken, clearAuth]);

  if (isRefreshing) {
    return (
      <div className="min-h-screen bg-bg-base text-text-primary font-mono flex flex-col items-center justify-center p-6">
        <div className="text-center space-y-4">
          <div className="text-sm tracking-wider uppercase animate-pulse">Initializing System Session...</div>
          <div className="w-48 h-1 bg-border relative overflow-hidden mx-auto">
            <div className="h-full bg-text-primary animate-pulse w-full"></div>
          </div>
        </div>
      </div>
    );
  }

  if (!user) {
    return <Navigate to="/auth/login" replace />;
  }

  return <Outlet />;
}
