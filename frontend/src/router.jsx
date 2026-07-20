import React from 'react';
import { createBrowserRouter } from 'react-router-dom';
import LandingPage from './pages/LandingPage';
import LoginPage from './pages/auth/LoginPage';
import RegisterPage from './pages/auth/RegisterPage';
import ForgotPasswordPage from './pages/auth/ForgotPasswordPage';
import VerifyOtpPage from './pages/auth/VerifyOtpPage';
import ResetPasswordPage from './pages/auth/ResetPasswordPage';
import ProtectedLayout from './layouts/ProtectedLayout';
import AdminLayout from './layouts/AdminLayout';
import AppLayout from './layouts/AppLayout';
import DashboardPage from './pages/DashboardPage';
import ModuleOverviewPage from './pages/ModuleOverviewPage';
import SectionPage from './pages/SectionPage';
import AssessmentPage from './pages/AssessmentPage';
import ProjectPage from './pages/ProjectPage';
import AdminDashboard from './pages/AdminDashboard';
import NotFoundPage from './pages/NotFoundPage';

import ProfilePage from './pages/ProfilePage';

export const router = createBrowserRouter([
  { path: '/', element: <LandingPage /> },
  { path: '/auth/login', element: <LoginPage /> },
  { path: '/auth/register', element: <RegisterPage /> },
  { path: '/auth/forgot-password', element: <ForgotPasswordPage /> },
  { path: '/auth/verify-otp', element: <VerifyOtpPage /> },
  { path: '/auth/reset-password', element: <ResetPasswordPage /> },
  {
    element: <ProtectedLayout />,
    children: [
      {
        element: <AppLayout />,
        children: [
          { path: '/dashboard', element: <DashboardPage /> },
          { path: '/profile', element: <ProfilePage /> },
          { path: '/modules/:moduleId', element: <ModuleOverviewPage /> },
          { path: '/modules/:moduleId/sections/:sectionId', element: <SectionPage /> },
          { path: '/modules/:moduleId/assessment', element: <AssessmentPage /> },
          { path: '/modules/:moduleId/project', element: <ProjectPage /> },
        ],
      },
    ],
  },
  {
    element: <AdminLayout />,
    children: [
      {
        element: <AppLayout />,
        children: [
          { path: '/admin', element: <AdminDashboard /> },
        ],
      },
    ],
  },
  { path: '*', element: <NotFoundPage /> },
]);
