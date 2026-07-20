import React from 'react';
import { useParams } from 'react-router-dom';
import { useQuery } from '@tanstack/react-query';
import ReactMarkdown from 'react-markdown';
import rehypeHighlight from 'rehype-highlight';
import api from '../lib/api';
import CodeBlock from '../components/ui/CodeBlock';
import QuizSection from '../components/quiz/QuizSection';
import { SectionContentSkeleton } from '../components/ui/Skeletons';

export default function SectionPage() {
  const { moduleId, sectionId } = useParams();

  // Query section details
  const { data: section, isLoading: sectionLoading, error: sectionError } = useQuery({
    queryKey: ['section', sectionId],
    queryFn: async () => {
      const res = await api.get(`/modules/${moduleId}/sections/${sectionId}`);
      return res.data.data;
    },
  });

  // Query module details to find the next section in order
  const { data: module, isLoading: moduleLoading } = useQuery({
    queryKey: ['module', moduleId],
    queryFn: async () => {
      const res = await api.get(`/modules/${moduleId}`);
      return res.data.data;
    },
  });

  if (sectionLoading || moduleLoading) {
    return (
      <div className="p-4 md:p-6 max-w-4xl mx-auto space-y-6">
        <SectionContentSkeleton />
      </div>
    );
  }

  if (sectionError || !section) {
    throw sectionError || new Error('Section not found');
  }

  // Calculate next section URL
  let nextSectionUrl = null;
  if (module && module.sections) {
    const currentIndex = module.sections.findIndex((s) => s.id === sectionId);
    if (currentIndex !== -1 && currentIndex < module.sections.length - 1) {
      const nextSec = module.sections[currentIndex + 1];
      nextSectionUrl = `/modules/${moduleId}/sections/${nextSec.id}`;
    }
  }

  const mdComponents = {
    pre: ({ children }) => {
      return <>{children}</>;
    },
    code: ({ className, children }) => {
      const isBlock = className && (className.includes('language-') || className.includes('hljs') || (typeof children === 'string' && children.includes('\n')));
      if (isBlock) {
        return <CodeBlock className={className}>{children}</CodeBlock>;
      }
      // Inline code: different style, no terminal treatment
      return (
        <code
          className="font-code text-sm px-1.5 py-0.5 rounded"
          style={{
            background: "var(--code-bg)",
            color: "var(--code-prompt)",
            border: "1px solid var(--code-border)",
          }}
        >
          {children}
        </code>
      );
    },
    blockquote({ children }) {
      return (
        <blockquote className="border-l-4 border-amber-500 bg-bg-elevated p-4 my-6 font-body text-text-secondary rounded-r text-sm">
          {children}
        </blockquote>
      );
    },
    table({ children }) {
      return (
        <div className="overflow-x-auto my-6 border border-border rounded max-w-full">
          <table className="min-w-full divide-y divide-border font-body text-sm text-left">
            {children}
          </table>
        </div>
      );
    },
    thead({ children }) {
      return (
        <thead className="bg-bg-surface text-text-primary uppercase font-bold text-[10px] tracking-wider border-b border-border">
          {children}
        </thead>
      );
    },
    tbody({ children }) {
      return <tbody className="divide-y divide-border bg-black">{children}</tbody>;
    },
    th({ children }) {
      return <th className="px-4 py-3 font-mono border-r border-border last:border-r-0">{children}</th>;
    },
    td({ children }) {
      return (
        <td className="px-4 py-3 font-mono border-r border-border last:border-r-0 text-text-secondary text-xs">
          {children}
        </td>
      );
    },
    p({ children }) {
      return <p className="font-body text-sm text-text-secondary leading-relaxed my-4">{children}</p>;
    },
    h1({ children }) {
      return <h1 className="font-display font-bold text-xl text-text-primary uppercase mt-6 mb-4">{children}</h1>;
    },
    h2({ children }) {
      return <h2 className="font-display font-bold text-lg text-text-primary uppercase mt-6 mb-3 border-b border-border pb-1">{children}</h2>;
    },
    h3({ children }) {
      return <h3 className="font-display font-bold text-base text-text-primary uppercase mt-5 mb-2">{children}</h3>;
    },
    ul({ children }) {
      return <ul className="list-disc pl-6 font-body text-sm text-text-secondary my-4 space-y-2">{children}</ul>;
    },
    ol({ children }) {
      return <ol className="list-decimal pl-6 font-body text-sm text-text-secondary my-4 space-y-2">{children}</ol>;
    },
    li({ children }) {
      return <li className="leading-relaxed">{children}</li>;
    },
  };

  return (
    <div className="p-4 md:p-6 max-w-4xl mx-auto space-y-8 animate-fade-in pb-24">
      {/* Title */}
      <div className="border-b border-border pb-4">
        <h2 className="text-2xl font-bold font-display uppercase tracking-wide text-text-primary">
          {section.title}
        </h2>
      </div>

      {/* Markdown Body */}
      <div className="prose prose-invert max-w-none">
        <ReactMarkdown rehypePlugins={[rehypeHighlight]} components={mdComponents}>
          {section.contentMd}
        </ReactMarkdown>
      </div>

      {/* Quiz Section */}
      <QuizSection
        key={sectionId}
        questions={section.quizQuestions}
        sectionId={sectionId}
        nextSectionUrl={nextSectionUrl}
      />
    </div>
  );
}
