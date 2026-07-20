import React, { useState, useEffect, useRef } from 'react';
import { Terminal } from 'xterm';
import { FitAddon } from 'xterm-addon-fit';
import { api } from '../../lib/api';
import 'xterm/css/xterm.css';

export default function TerminalPanel() {
  const [isOpen, setIsOpen] = useState(false);
  const [connectionStatus, setConnectionStatus] = useState('idle'); // idle, connecting, connected, error, disconnected

  const containerRef = useRef(null);
  const terminalRef = useRef(null);
  const fitAddonRef = useRef(null);
  const socketRef = useRef(null);
  const xtermRef = useRef(null);

  // Helper to format WebSocket URL
  const getWsUrl = (token) => {
    const apiBase = import.meta.env.VITE_API_URL ?? 'http://localhost:8080';
    try {
      const url = new URL(apiBase);
      const wsProtocol = url.protocol === 'https:' ? 'wss://' : 'ws://';
      return `${wsProtocol}${url.host}/ws/terminal?token=${token}`;
    } catch {
      const wsProtocol = apiBase.startsWith('https') ? 'wss://' : 'ws://';
      const wsHost = apiBase.replace(/^https?:\/\//, '').split('/')[0];
      return `${wsProtocol}${wsHost}/ws/terminal?token=${token}`;
    }
  };

  useEffect(() => {
    if (!isOpen) {
      // Clean up connection when panel is closed
      if (socketRef.current) {
        socketRef.current.close();
        socketRef.current = null;
      }
      if (xtermRef.current) {
        xtermRef.current.dispose();
        xtermRef.current = null;
      }
      fitAddonRef.current = null;
      setTimeout(() => {
        setConnectionStatus('idle');
      }, 0);
      return;
    }

    let isMounted = true;
    let ws = null;
    let term = null;

    const initTerminal = async () => {
      setConnectionStatus('connecting');
      try {
        // 1. Fetch session token from API
        const { data } = await api.post('/api/v1/terminal/session');
        const token = data.data.sessionToken;

        if (!isMounted) return;

        // 2. Initialize Xterm instance
        term = new Terminal({
          fontFamily: '"JetBrains Mono", monospace',
          fontSize: 13,
          theme: {
            background: '#000000',
            foreground: '#FFFFFF',
            cursor: '#FFFFFF',
            selectionBackground: '#2A2A2A',
          },
          cursorBlink: true,
        });

        const fitAddon = new FitAddon();
        term.loadAddon(fitAddon);

        xtermRef.current = term;
        fitAddonRef.current = fitAddon;

        // Open terminal in ref
        if (terminalRef.current) {
          term.open(terminalRef.current);
          fitAddon.fit();
        }

        // 3. Connect to WebSocket
        const wsUrl = getWsUrl(token);
        ws = new WebSocket(wsUrl);
        socketRef.current = ws;

        ws.onopen = () => {
          if (!isMounted) return;
          setConnectionStatus('connected');
          term.focus();
          // Initial fit
          setTimeout(() => {
            if (fitAddonRef.current) fitAddonRef.current.fit();
          }, 100);
        };

        ws.onmessage = (event) => {
          if (!isMounted) return;
          term.write(event.data);
        };

        ws.onclose = () => {
          if (!isMounted) return;
          setConnectionStatus('disconnected');
        };

        ws.onerror = () => {
          if (!isMounted) return;
          setConnectionStatus('error');
        };

        // Bridge terminal keystrokes to websocket
        term.onData((data) => {
          if (ws && ws.readyState === WebSocket.OPEN) {
            ws.send(data);
          }
        });

      } catch (err) {
        console.error('Failed to initialize terminal session:', err);
        if (isMounted) {
          setConnectionStatus('error');
        }
      }
    };

    initTerminal();

    // Resize listener
    const handleResize = () => {
      if (fitAddonRef.current) {
        fitAddonRef.current.fit();
      }
    };
    window.addEventListener('resize', handleResize);

    return () => {
      isMounted = false;
      window.removeEventListener('resize', handleResize);
      if (ws) {
        ws.close();
      }
      if (term) {
        term.dispose();
      }
    };
  }, [isOpen]);

  // Handle panel refit when slide transition finishes
  useEffect(() => {
    if (isOpen) {
      const timer = setTimeout(() => {
        if (fitAddonRef.current) {
          fitAddonRef.current.fit();
        }
      }, 300); // matches slide transition
      return () => clearTimeout(timer);
    }
  }, [isOpen]);

  const getStatusDot = () => {
    switch (connectionStatus) {
      case 'connected':
        return <div className="w-2.5 h-2.5 rounded-full bg-white border border-white" title="Connected" />;
      case 'connecting':
        return <div className="w-2.5 h-2.5 rounded-full bg-[#525252] animate-pulse border border-[#A3A3A3]" title="Connecting..." />;
      default:
        return <div className="w-2.5 h-2.5 rounded-full bg-transparent border border-[#525252]" title="Disconnected" />;
    }
  };

  return (
    <div
      ref={containerRef}
      className={`fixed bottom-0 left-0 right-0 bg-bg-base border-t border-border z-30 transition-all duration-300 ease-in-out ${
        isOpen ? 'h-[100vh] md:h-[320px]' : 'h-10'
      }`}
    >
      {/* Handle Bar */}
      <div
        onClick={() => setIsOpen((prev) => !prev)}
        className="h-10 bg-bg-surface hover:bg-bg-elevated border-b border-border px-4 flex items-center justify-between cursor-pointer select-none"
      >
        <div className="flex items-center gap-2">
          <span className="font-display text-xs font-bold uppercase tracking-wider text-text-primary">
            Terminal Sandbox
          </span>
          {getStatusDot()}
        </div>

        <div className="text-text-secondary flex items-center gap-2">
          {isOpen && (
            <button
              onClick={(e) => {
                e.stopPropagation();
                setIsOpen(false);
              }}
              className="md:hidden px-2.5 py-1 border border-border rounded text-[10px] font-bold text-text-primary hover:bg-bg-elevated cursor-pointer"
            >
              CLOSE [X]
            </button>
          )}
          <svg
            className={`w-4 h-4 transition-transform duration-200 ${isOpen ? 'rotate-180' : ''} ${isOpen ? 'hidden md:block' : ''}`}
            fill="none"
            viewBox="0 0 24 24"
            stroke="currentColor"
          >
            <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={2} d="M5 15l7-7 7 7" />
          </svg>
        </div>
      </div>

      {/* Terminal View Container */}
      <div
        className={`w-full bg-black p-2 overflow-hidden transition-all duration-300 ${
          isOpen ? 'h-[calc(100vh-40px)] md:h-[280px] opacity-100' : 'h-0 opacity-0 pointer-events-none'
        }`}
      >
        <div ref={terminalRef} className="w-full h-full" />
      </div>
    </div>
  );
}
