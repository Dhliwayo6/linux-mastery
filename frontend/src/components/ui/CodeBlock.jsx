import React, { useState } from 'react';

const getTextFromNode = (node) => {
  if (node == null) return "";
  if (typeof node === "string" || typeof node === "number") return String(node);
  if (Array.isArray(node)) return node.map(getTextFromNode).join("");
  if (node.props && node.props.children) return getTextFromNode(node.props.children);
  return "";
};

export default function CodeBlock({ children, className }) {
  const language = className?.replace("language-", "") || "";
  const code = getTextFromNode(children).trimEnd();
  const lines = code.split("\n");
  const multiLine = lines.length > 1;
  const [copied, setCopied] = useState(false);

  const handleCopy = () => {
    navigator.clipboard.writeText(code).then(() => {
      setCopied(true);
      setTimeout(() => setCopied(false), 2000);
    });
  };

  const showLanguage = language && language !== "undefined" && language !== "text";

  return (
    <div className="my-6 border border-[var(--code-border)] rounded-[6px] overflow-hidden bg-[var(--code-bg)] font-[family:var(--font-code)] text-[13px] shadow-md select-text">
      {/* Terminal header bar */}
      <div className="flex items-center justify-between px-3 py-1.5 bg-[var(--code-header-bg)] border-b border-[var(--code-border)] select-none text-[11px]">
        {/* Traffic dots */}
        <div className="flex gap-[4px]" aria-hidden="true">
          <span className="w-[8px] h-[8px] rounded-full bg-[var(--code-dot-close)]"></span>
          <span className="w-[8px] h-[8px] rounded-full bg-[var(--code-dot-min)]"></span>
          <span className="w-[8px] h-[8px] rounded-full bg-[var(--code-dot-max)]"></span>
        </div>

        {/* Language label */}
        {showLanguage && (
          <span className="hidden md:block text-[var(--code-ln-color)] lowercase font-[family:var(--font-code)] ml-4 mr-auto">
            {language}
          </span>
        )}

        {/* Copy button */}
        <button
          onClick={handleCopy}
          className="ml-auto bg-transparent border-none p-0 cursor-pointer font-[family:var(--font-code)] text-[11px] select-none outline-none transition-colors duration-150 text-[var(--code-copy-idle)] hover:text-[var(--code-copy-hover)]"
          style={{
            color: copied ? "var(--code-copy-success)" : undefined,
          }}
        >
          {copied ? "Copied!" : "Copy"}
        </button>
      </div>

      {/* Code body */}
      <div className="py-3 px-4 flex">
        {/* Line numbers (desktop only, multi-line only) */}
        {multiLine && (
          <span
            className="hidden md:flex flex-col text-right select-none pr-3 mr-3 border-r border-[var(--code-border)] text-[var(--code-ln-color)] font-[family:var(--font-code)] leading-[1.6]"
            aria-hidden="true"
            style={{ minWidth: "2ch" }}
          >
            {lines.map((_, i) => (
              <span key={i}>{i + 1}</span>
            ))}
          </span>
        )}

        {/* Code representation */}
        <pre
          className="flex-1 overflow-x-auto whitespace-pre text-[var(--code-text)] font-[family:var(--font-code)] leading-[1.6] min-w-0"
          style={{ WebkitOverflowScrolling: "touch" }}
        >
          <code className={(className || "") + " whitespace-pre"}>
            {language === "bash" && (
              <span className="text-[var(--code-prompt)] select-none mr-2">$</span>
            )}
            {children}
          </code>
        </pre>
      </div>
    </div>
  );
}

export { CodeBlock };
