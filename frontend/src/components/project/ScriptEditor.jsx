import React, { useEffect, useRef } from 'react';
import { EditorState } from '@codemirror/state';
import { EditorView, keymap, drawSelection } from '@codemirror/view';
import { defaultKeymap, history, historyKeymap } from '@codemirror/commands';
import { StreamLanguage } from '@codemirror/language';
import { shell } from '@codemirror/legacy-modes/mode/shell';

export default function ScriptEditor({ value, onChange, readOnly = false }) {
  const containerRef = useRef(null);
  const viewRef = useRef(null);
  const onChangeRef = useRef(onChange);

  // Sync onChange handler ref
  useEffect(() => {
    onChangeRef.current = onChange;
  }, [onChange]);

  useEffect(() => {
    if (!containerRef.current) return;

    // Custom retro theme styling matching global monospaced design tokens
    const retroTheme = EditorView.theme({
      "&": {
        color: "#FFFFFF",
        backgroundColor: "#000000",
        fontFamily: "'JetBrains Mono', 'IBM Plex Mono', monospace",
        fontSize: "13px",
        height: "100%",
        minHeight: "100%",
      },
      ".cm-content": {
        caretColor: "#00FF00",
        padding: "16px 0",
      },
      "&.cm-focused .cm-cursor": {
        borderLeft: "2px solid #00FF00",
      },
      "&.cm-focused .cm-selectionBackground, ::selection": {
        backgroundColor: "#222222",
      },
      ".cm-gutters": {
        backgroundColor: "#000000",
        color: "#525252",
        border: "none",
        borderRight: "1px solid #2A2A2A",
        paddingRight: "8px",
      },
      ".cm-activeLine": {
        backgroundColor: "#0A0A0A",
      },
      ".cm-activeLineGutter": {
        backgroundColor: "#0A0A0A",
        color: "#A3A3A3",
      }
    }, { dark: true });

    const state = EditorState.create({
      doc: value || '',
      extensions: [
        history(),
        drawSelection(),
        StreamLanguage.define(shell),
        retroTheme,
        keymap.of([...defaultKeymap, ...historyKeymap]),
        EditorState.readOnly.of(readOnly),
        EditorView.updateListener.of((update) => {
          if (update.docChanged && onChangeRef.current) {
            onChangeRef.current(update.state.doc.toString());
          }
        }),
      ],
    });

    const view = new EditorView({
      state,
      parent: containerRef.current,
    });

    viewRef.current = view;

    return () => {
      view.destroy();
    };
    // eslint-disable-next-line react-hooks/exhaustive-deps
  }, [readOnly]); // Re-create state when readOnly state toggles

  // Sync value updates from outside, avoiding cursor resets
  useEffect(() => {
    const view = viewRef.current;
    if (view && value !== view.state.doc.toString()) {
      view.dispatch({
        changes: { from: 0, to: view.state.doc.length, insert: value || '' }
      });
    }
  }, [value]);

  return (
    <div
      ref={containerRef}
      className="w-full border border-border rounded bg-black overflow-hidden h-[250px] md:h-[450px]"
    />
  );
}
