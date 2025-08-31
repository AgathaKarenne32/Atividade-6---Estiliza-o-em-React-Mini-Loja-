module.exports = {
  content: ["./index.html","./src/**/*.{js,jsx}"],
  darkMode: 'class',
  theme: {
    extend: {
      borderRadius: { DEFAULT: '12px' },
      screens: { xs: {'max':'480px'}, smx: {'min':'481px','max':'768px'}, mdx: {'min':'769px','max':'1024px'}, lgx: {'min':'1025px'} }
    }
  },
  plugins: [require('@tailwindcss/line-clamp')],
}
