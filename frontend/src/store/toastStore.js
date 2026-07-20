import { create } from 'zustand';

export const useToastStore = create((set) => ({
  toasts: [],
  addToast: (type, message) => {
    const id = Math.random().toString(36).substring(2, 9);
    set((state) => {
      // Keep at most 3 toasts in the stack
      const nextToasts = [...state.toasts, { id, type, message }].slice(-3);
      return { toasts: nextToasts };
    });

    // Auto dismiss after 4 seconds
    setTimeout(() => {
      set((state) => ({
        toasts: state.toasts.filter((t) => t.id !== id),
      }));
    }, 4000);
  },
  removeToast: (id) =>
    set((state) => ({
      toasts: state.toasts.filter((t) => t.id !== id),
    })),
}));
