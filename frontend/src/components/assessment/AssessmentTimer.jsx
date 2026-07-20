import React, { useState, useEffect, useRef } from 'react';

export default function AssessmentTimer({ totalSeconds = 900, onExpire }) {
  const [secondsLeft, setSecondsLeft] = useState(totalSeconds);
  const [announcement, setAnnouncement] = useState('');
  const onExpireRef = useRef(onExpire);

  useEffect(() => {
    onExpireRef.current = onExpire;
  }, [onExpire]);

  useEffect(() => {
    if (secondsLeft <= 0) {
      if (onExpireRef.current) onExpireRef.current();
      return;
    }

    // Accessibility announcements
    if (secondsLeft === 300) {
      setTimeout(() => setAnnouncement('5 minutes remaining'), 0);
    } else if (secondsLeft === 60) {
      setTimeout(() => setAnnouncement('1 minute remaining'), 0);
    }

    const timer = setInterval(() => {
      setSecondsLeft((prev) => prev - 1);
    }, 1000);

    return () => clearInterval(timer);
  }, [secondsLeft]);

  const formatTime = (secs) => {
    const m = Math.floor(secs / 60);
    const s = secs % 60;
    return `${String(m).padStart(2, '0')}:${String(s).padStart(2, '0')}`;
  };

  // Pulse animation mapping
  let animationClass = '';
  if (secondsLeft <= 60) {
    animationClass = 'font-bold animate-[pulse_0.5s_infinite]';
  } else if (secondsLeft <= 300) {
    animationClass = 'font-bold animate-[pulse_1.5s_infinite]';
  }

  return (
    <div className="font-mono text-sm select-none flex items-center gap-2">
      {/* Screen reader announcement wrapper */}
      <span aria-live="assertive" className="sr-only">
        {announcement}
      </span>
      <span className="text-text-muted">TIME REMAINING:</span>
      <span className={`text-text-primary ${animationClass}`}>
        {formatTime(secondsLeft)}
      </span>
    </div>
  );
}
