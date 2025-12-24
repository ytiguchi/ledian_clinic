/** @type {import('tailwindcss').Config} */
export default {
  content: ['./src/**/*.{astro,html,js,jsx,md,mdx,svelte,ts,tsx,vue}'],
  theme: {
    extend: {
      colors: {
        primary: {
          DEFAULT: '#1a1a1a',
          light: '#2d2d2d',
        },
        accent: {
          DEFAULT: '#C9A86C',
          light: '#E8D5B5',
        },
        bg: {
          DEFAULT: '#FAF8F5',
          card: '#FFFFFF',
        },
      },
      fontFamily: {
        sans: ['Zen Kaku Gothic New', '-apple-system', 'sans-serif'],
        serif: ['Cormorant Garamond', 'serif'],
      },
    },
  },
  plugins: [],
}

