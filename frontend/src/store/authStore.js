import { create } from 'zustand';

const parseJwt = (token) => {
  try {
    const base64Url = token.split('.')[1];
    const base64 = base64Url.replace(/-/g, '+').replace(/_/g, '/');
    const jsonPayload = decodeURIComponent(
      window
        .atob(base64)
        .split('')
        .map((c) => '%' + ('00' + c.charCodeAt(0).toString(16)).slice(-2))
        .join('')
    );
    return JSON.parse(jsonPayload);
  } catch {
    return null;
  }
};

export const useAuthStore = create((set) => {
  let initialUser = null;
  try {
    const cached = localStorage.getItem('user_profile');
    if (cached) initialUser = JSON.parse(cached);
  } catch {
    console.warn('Could not restore user profile from local storage');
  }

  return {
    user: initialUser,
    accessToken: null,
    updateUser: (updatedFields) => {
      set((state) => {
        const newUser = { ...state.user, ...updatedFields };
        localStorage.setItem('user_profile', JSON.stringify(newUser));
        return { user: newUser };
      });
    },
    setAuth: (user, token) => {
      let finalUser = user;
      if (token) {
        const decoded = parseJwt(token);
        if (decoded) {
          finalUser = {
            id: decoded.sub,
            role: decoded.role,
            email: user?.email || decoded.sub,
            displayName: user?.displayName || user?.email || decoded.sub,
            ...user,
          };
        }
      }
      if (finalUser) {
        localStorage.setItem('user_profile', JSON.stringify(finalUser));
      } else {
        localStorage.removeItem('user_profile');
      }
      set({ user: finalUser, accessToken: token });
    },
    setAccessToken: (token) => {
      const decoded = parseJwt(token);
      set((state) => {
        let finalUser = state.user;
        if (decoded) {
          finalUser = {
            ...state.user,
            id: decoded.sub,
            role: decoded.role,
          };
          localStorage.setItem('user_profile', JSON.stringify(finalUser));
        }
        return { user: finalUser, accessToken: token };
      });
    },
    clearAuth: () => {
      localStorage.removeItem('user_profile');
      set({ user: null, accessToken: null });
    },
  };
});
