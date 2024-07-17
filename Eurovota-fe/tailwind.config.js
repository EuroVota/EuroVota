/** @type {import('tailwindcss').Config} */
module.exports = {
  content: [
    "./index.html",
    "./src/**/*.{js,ts,jsx,tsx}",
  ],
  theme: {
    extend: {
      backgroundImage: {
        'header-bg': "url('/path/to/header-bg.jpg')",
        'side-bg': "./src/assets/side-bg.jpg",
      },
    },
  },
  plugins: [],
};
