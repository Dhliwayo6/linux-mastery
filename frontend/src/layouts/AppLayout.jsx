import React, { useState } from 'react';
import { Outlet } from 'react-router-dom';
import Topbar from '../components/layout/Topbar';
import Sidebar from '../components/layout/Sidebar';
import TerminalPanel from '../components/terminal/TerminalPanel';
import ToastContainer from '../components/ui/ToastContainer';

export default function AppLayout() {
  const [sidebarOpen, setSidebarOpen] = useState(false);

  return (
    <div className="min-h-screen bg-bg-base text-text-primary font-mono flex flex-col overflow-hidden">
      {/* Topbar */}
      <Topbar onToggleSidebar={() => setSidebarOpen((prev) => !prev)} />

      <div className="flex flex-1 relative overflow-hidden">
        {/* Sidebar */}
        <Sidebar isOpen={sidebarOpen} onClose={() => setSidebarOpen(false)} />

        {/* Main Content Area */}
        <main className="flex-1 overflow-y-auto pb-48 bg-bg-base relative">
          <Outlet />
        </main>
      </div>

      {/* Terminal Panel */}
      <TerminalPanel />

      {/* Toast notifications */}
      <ToastContainer />
    </div>
  );
}
