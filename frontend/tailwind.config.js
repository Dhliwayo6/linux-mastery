export default {
  content: ['./index.html', './src/**/*.{js,jsx}'],
  theme: {
    extend: {
      colors: {
        'bg-base':        '#000000',
        'bg-surface':     '#0A0A0A',
        'bg-elevated':    '#161616',
        'bg-terminal':    '#000000',
        'text-primary':   '#FFFFFF',
        'text-secondary': '#A3A3A3',
        'text-muted':     '#525252',
        'border':         '#2A2A2A',
        'border-trace':   '#FFFFFF',
        'border-subtle':  '#161616',
      },
      fontFamily: {
        display: ['"JetBrains Mono"', 'monospace'],
        body:    ['"IBM Plex Mono"', 'monospace'],
        code:    ['"JetBrains Mono"', 'monospace'],
      },
    },
  },
  plugins: [],
}
