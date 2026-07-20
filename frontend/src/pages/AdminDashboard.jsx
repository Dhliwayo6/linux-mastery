import React, { useState } from 'react';
import { useQuery, useMutation } from '@tanstack/react-query';
import api from '../lib/api';
import { useToastStore } from '../store/toastStore';
import { SectionContentSkeleton } from '../components/ui/Skeletons';

export default function AdminDashboard() {
  const addToast = useToastStore((state) => state.addToast);

  const [activeTab, setActiveTab] = useState('users'); // 'users' | 'questions'
  const [selectedModuleId, setSelectedModuleId] = useState('');
  const [editingQuestion, setEditingQuestion] = useState(null); // null for list, {} for new, or {question} to edit

  // Form states
  const [questionText, setQuestionText] = useState('');
  const [optionsJson, setOptionsJson] = useState('');
  const [correctAnswer, setCorrectAnswer] = useState('');
  const [explanation, setExplanation] = useState('');

  // 1. Fetch Users
  const { data: usersList, isLoading: usersLoading } = useQuery({
    queryKey: ['adminUsers'],
    queryFn: async () => {
      const res = await api.get('/admin/users');
      return res.data.data;
    },
    enabled: activeTab === 'users',
  });

  // 2. Fetch Modules (using progress endpoint to get all 7 seeded modules)
  const { data: progressList } = useQuery({
    queryKey: ['progress'],
    queryFn: async () => {
      const res = await api.get('/progress');
      return res.data.data;
    },
  });

  // Automatically select the first module if not set
  React.useEffect(() => {
    if (progressList?.length > 0 && !selectedModuleId) {
      const firstId = progressList[0].moduleId;
      setTimeout(() => setSelectedModuleId(firstId), 0);
    }
  }, [progressList, selectedModuleId]);

  // 3. Fetch Assessment Questions for selected module
  const { data: questionsList, isLoading: questionsLoading, refetch: refetchQuestions } = useQuery({
    queryKey: ['adminQuestions', selectedModuleId],
    queryFn: async () => {
      const res = await api.get(`/admin/questions?moduleId=${selectedModuleId}`);
      return res.data.data;
    },
    enabled: activeTab === 'questions' && !!selectedModuleId,
  });

  // 4. Mutations
  const createMutation = useMutation({
    mutationFn: async (payload) => {
      const res = await api.post('/admin/questions', payload);
      return res.data.data;
    },
    onSuccess: () => {
      addToast('success', 'Question created successfully ✓');
      refetchQuestions();
      setEditingQuestion(null);
    },
    onError: (err) => {
      console.error(err);
      addToast('error', 'Failed to create question.');
    },
  });

  const updateMutation = useMutation({
    mutationFn: async ({ id, payload }) => {
      const res = await api.put(`/admin/questions/${id}`, payload);
      return res.data.data;
    },
    onSuccess: () => {
      addToast('success', 'Question updated successfully ✓');
      refetchQuestions();
      setEditingQuestion(null);
    },
    onError: (err) => {
      console.error(err);
      addToast('error', 'Failed to update question.');
    },
  });

  const deleteMutation = useMutation({
    mutationFn: async (id) => {
      await api.delete(`/admin/questions/${id}`);
    },
    onSuccess: () => {
      addToast('success', 'Question deleted ✓');
      refetchQuestions();
    },
    onError: (err) => {
      console.error(err);
      addToast('error', 'Failed to delete question.');
    },
  });

  const handleOpenForm = (q) => {
    if (q) {
      setEditingQuestion(q);
      setQuestionText(q.questionText || '');
      setOptionsJson(q.optionsJson || '');
      setCorrectAnswer(q.correctAnswer || '');
      setExplanation(q.explanation || '');
    } else {
      setEditingQuestion({});
      setQuestionText('');
      setOptionsJson('[\n  {"id": "A", "text": "Option A"},\n  {"id": "B", "text": "Option B"}\n]');
      setCorrectAnswer('A');
      setExplanation('');
    }
  };

  const handleSave = (e) => {
    e.preventDefault();

    // Basic JSON validation
    try {
      JSON.parse(optionsJson);
    } catch (err) {
      console.error(err);
      addToast('error', 'Invalid Options JSON format.');
      return;
    }

    const payload = {
      moduleId: selectedModuleId,
      questionText,
      options: JSON.parse(optionsJson),
      correctAnswer,
      explanation,
    };

    if (editingQuestion.id) {
      updateMutation.mutate({ id: editingQuestion.id, payload });
    } else {
      createMutation.mutate(payload);
    }
  };

  const handleDelete = (id) => {
    if (window.confirm('Are you sure you want to delete this question?')) {
      deleteMutation.mutate(id);
    }
  };

  return (
    <div className="p-6 max-w-6xl mx-auto space-y-8 animate-fade-in select-none">
      {/* Title bar */}
      <div className="border-b border-border pb-4 flex items-center justify-between">
        <div>
          <h2 className="text-xl font-bold font-display uppercase tracking-wide text-text-primary">
            Admin Console
          </h2>
          <p className="text-text-secondary text-xs font-body mt-1">
            Monitor students progress metrics and manage curriculum assessments.
          </p>
        </div>
      </div>

      {/* Tabs list */}
      <div className="flex border-b border-border font-display text-xs font-bold uppercase">
        <button
          onClick={() => {
            setActiveTab('users');
            setEditingQuestion(null);
          }}
          className={`px-6 py-3 cursor-pointer border-b-2 transition-all ${
            activeTab === 'users' ? 'border-text-primary text-text-primary' : 'border-transparent text-text-muted hover:text-text-secondary'
          }`}
        >
          User Progress tracking
        </button>
        <button
          onClick={() => setActiveTab('questions')}
          className={`px-6 py-3 cursor-pointer border-b-2 transition-all ${
            activeTab === 'questions' ? 'border-text-primary text-text-primary' : 'border-transparent text-text-muted hover:text-text-secondary'
          }`}
        >
          Assessment Question Management
        </button>
      </div>

      {/* Tab Contents: Users List */}
      {activeTab === 'users' && (
        <div className="space-y-4">
          {usersLoading ? (
            <SectionContentSkeleton />
          ) : (
            <div className="border border-border rounded-lg bg-bg-surface overflow-hidden">
              <table className="min-w-full divide-y divide-border text-left font-mono text-xs">
                <thead>
                  <tr className="bg-black text-text-muted">
                    <th className="px-4 py-3">UID</th>
                    <th className="px-4 py-3">DISPLAY NAME</th>
                    <th className="px-4 py-3">EMAIL</th>
                    <th className="px-4 py-3">ROLE</th>
                    <th className="px-4 py-3 text-right">COMPLETED MODULES</th>
                  </tr>
                </thead>
                <tbody className="divide-y divide-border/60">
                  {usersList?.map((usr) => (
                    <tr key={usr.id} className="hover:bg-bg-elevated transition-colors text-text-secondary">
                      <td className="px-4 py-3 font-semibold">{usr.id?.substring(0, 8)}...</td>
                      <td className="px-4 py-3 text-text-primary">{usr.displayName || '(Not set)'}</td>
                      <td className="px-4 py-3">{usr.email}</td>
                      <td className="px-4 py-3">
                        <span className={`px-1.5 py-0.5 rounded text-[10px] ${
                          usr.role === 'ADMIN' ? 'bg-red-950/20 text-red-400 border border-red-900/50' : 'bg-bg-elevated text-text-muted border border-border'
                        }`}>
                          {usr.role}
                        </span>
                      </td>
                      <td className="px-4 py-3 text-right text-text-primary font-bold">{usr.modulesCompleted} / 7</td>
                    </tr>
                  ))}
                </tbody>
              </table>
            </div>
          )}
        </div>
      )}

      {/* Tab Contents: Question management */}
      {activeTab === 'questions' && (
        <div className="space-y-6">
          {/* Module Selector & Create Button */}
          <div className="flex flex-wrap items-center justify-between gap-4 bg-bg-surface border border-border p-4 rounded-lg">
            <div className="flex items-center gap-3">
              <span className="font-mono text-xs text-text-secondary uppercase">Select Module:</span>
              <select
                value={selectedModuleId}
                onChange={(e) => {
                  setSelectedModuleId(e.target.value);
                  setEditingQuestion(null);
                }}
                className="bg-black border border-border p-2 rounded text-xs font-mono text-text-primary outline-none focus:border-text-primary"
              >
                {progressList?.map((m) => (
                  <option key={m.moduleId} value={m.moduleId}>
                    {m.moduleTitle}
                  </option>
                ))}
              </select>
            </div>

            {!editingQuestion && (
              <button
                onClick={() => handleOpenForm(null)}
                className="bg-text-primary text-black font-bold px-4 py-2 rounded text-xs hover:opacity-90 transition-opacity cursor-pointer"
              >
                CREATE QUESTION
              </button>
            )}
          </div>

          {/* Create/Edit Form view */}
          {editingQuestion ? (
            <div className="border border-border p-6 rounded-lg bg-bg-surface space-y-6">
              <div className="flex items-center justify-between border-b border-border pb-3">
                <span className="font-display font-bold text-xs uppercase text-text-primary">
                  {editingQuestion.id ? 'EDIT QUESTION' : 'NEW QUESTION'}
                </span>
                <button
                  onClick={() => setEditingQuestion(null)}
                  className="text-text-muted hover:text-text-primary font-mono text-xs cursor-pointer"
                >
                  [x] CANCEL
                </button>
              </div>

              <form onSubmit={handleSave} className="space-y-4 font-mono text-xs">
                {/* Question Text */}
                <div className="space-y-1">
                  <label className="text-text-muted uppercase block">Question Text</label>
                  <textarea
                    required
                    value={questionText}
                    onChange={(e) => setQuestionText(e.target.value)}
                    rows={4}
                    placeholder="Enter the question details..."
                    className="w-full bg-black text-text-primary border border-border p-3 rounded font-mono text-xs outline-none focus:border-text-primary"
                  />
                </div>

                {/* Options JSON */}
                <div className="space-y-1">
                  <label className="text-text-muted uppercase block">Options JSON Array</label>
                  <textarea
                    required
                    value={optionsJson}
                    onChange={(e) => setOptionsJson(e.target.value)}
                    rows={5}
                    placeholder="Options details JSON..."
                    className="w-full bg-black text-text-primary border border-border p-3 rounded font-mono text-xs outline-none focus:border-text-primary"
                  />
                </div>

                {/* Correct Answer */}
                <div className="space-y-1">
                  <label className="text-text-muted uppercase block">Correct Answer ID</label>
                  <input
                    required
                    type="text"
                    value={correctAnswer}
                    onChange={(e) => setCorrectAnswer(e.target.value)}
                    placeholder="e.g. A"
                    className="w-32 bg-black text-text-primary border border-border p-3 rounded font-mono text-xs outline-none focus:border-text-primary"
                  />
                </div>

                {/* Explanation */}
                <div className="space-y-1">
                  <label className="text-text-muted uppercase block">Explanation Text</label>
                  <textarea
                    required
                    value={explanation}
                    onChange={(e) => setExplanation(e.target.value)}
                    rows={3}
                    placeholder="Why is this answer correct?..."
                    className="w-full bg-black text-text-primary border border-border p-3 rounded font-mono text-xs outline-none focus:border-text-primary"
                  />
                </div>

                <div className="flex gap-4 pt-4 border-t border-border">
                  <button
                    type="submit"
                    className="bg-text-primary text-black font-bold px-6 py-2.5 rounded hover:opacity-90 transition-opacity cursor-pointer"
                  >
                    SAVE
                  </button>
                  <button
                    type="button"
                    onClick={() => setEditingQuestion(null)}
                    className="border border-border text-text-secondary hover:bg-bg-elevated px-6 py-2.5 rounded transition-all cursor-pointer"
                  >
                    CANCEL
                  </button>
                </div>
              </form>
            </div>
          ) : (
            /* Questions List view */
            <div className="space-y-4">
              {questionsLoading ? (
                <SectionContentSkeleton />
              ) : questionsList?.length > 0 ? (
                <div className="space-y-4">
                  {questionsList.map((q, idx) => (
                    <div key={q.id} className="border border-border p-6 rounded-lg bg-bg-surface/50 space-y-4 font-mono text-xs">
                      <div className="flex items-center justify-between border-b border-border/40 pb-2">
                        <span className="text-text-muted font-bold">QUESTION #{idx + 1}</span>
                        <div className="flex gap-3">
                          <button
                            onClick={() => handleOpenForm(q)}
                            className="text-text-secondary hover:text-text-primary cursor-pointer"
                          >
                            [EDIT]
                          </button>
                          <button
                            onClick={() => handleDelete(q.id)}
                            className="text-red-400 hover:text-red-300 cursor-pointer"
                          >
                            [DELETE]
                          </button>
                        </div>
                      </div>

                      <div className="space-y-3">
                        <p className="text-text-primary font-display font-bold leading-relaxed">{q.questionText}</p>

                        {/* Options summary */}
                        <div className="space-y-1 text-text-secondary pl-4 border-l border-border/50">
                          {(() => {
                            try {
                              const opts = JSON.parse(q.optionsJson);
                              return opts.map((opt) => (
                                <div key={opt.id}>
                                  <span className="font-bold text-text-muted mr-1.5 uppercase">{opt.id}:</span>
                                  {opt.text}
                                </div>
                              ));
                            } catch (e) {
                              console.error(e);
                              return <span className="text-red-400">Error rendering options JSON</span>;
                            }
                          })()}
                        </div>

                        <div className="flex gap-2">
                          <span className="text-text-muted">CORRECT ANSWER:</span>
                          <span className="text-[#00FF00] font-bold uppercase">{q.correctAnswer}</span>
                        </div>

                        <div>
                          <span className="text-text-muted block mb-1">EXPLANATION:</span>
                          <p className="text-text-secondary leading-relaxed font-body">{q.explanation}</p>
                        </div>
                      </div>
                    </div>
                  ))}
                </div>
              ) : (
                <p className="text-text-muted font-body text-xs text-center py-6 border border-border border-dashed rounded-lg">
                  No assessment questions found for this module yet.
                </p>
              )}
            </div>
          )}
        </div>
      )}
    </div>
  );
}
