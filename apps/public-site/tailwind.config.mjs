/** @type {import('tailwindcss').Config} */
export default {
  content: ['./src/**/*.{astro,html,js,jsx,md,mdx,svelte,ts,tsx,vue}'],
  theme: {
    extend: {
      colors: {
        // 現サイト完全一致カラーパレット
        bg: {
          DEFAULT: '#FFFCFA',       // 温かみのある白
          gray: '#EFF2F4',          // ライトグレー
          dark: '#2D2D2D',          // ダークグレー
        },
        blue: {
          DEFAULT: '#5885A3',       // ブルーアクセント
          light: '#7BA3C0',
          dark: '#4A7291',
        },
        coral: {
          DEFAULT: '#FFA989',       // コーラル/サーモン
          light: '#FFCAB5',
          dark: '#E89070',
        },
        gray: {
          medium: '#B6BCBE',
          light: '#EFF2F4',
        },
        txt: {
          DEFAULT: '#000000',
          dark: '#2D2D2D',
          light: '#666666',
          muted: '#999999',
        },
        border: {
          DEFAULT: '#e5e0d8',
          light: '#f0ece6',
        },
      },
      fontFamily: {
        // 現サイト完全一致フォント
        sans: ['Noto Sans JP', 'Hiragino Kaku Gothic ProN', 'Hiragino Sans', 'Meiryo', 'sans-serif'],
        serif: ['Noto Serif JP', 'Hiragino Mincho ProN', 'YuMincho', 'Yu Mincho', 'serif'],
      },
      fontSize: {
        '2xs': '0.625rem',
        '3xs': '0.5rem',
      },
      spacing: {
        '18': '4.5rem',
        '22': '5.5rem',
      },
      letterSpacing: {
        'widest-plus': '0.2em',
      },
      aspectRatio: {
        '4/3': '4 / 3',
        '16/10': '16 / 10',
      },
      lineHeight: {
        'relaxed': '1.8',
        'loose': '2',
      },
    },
  },
  plugins: [],
};
