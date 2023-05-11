module.exports = {
  async rewrites() {
    return {
      fallback: [
        {
          source: '/:path*',
          destination: '/:path*',
        },
        {
          source: '/:path*',
          destination: `http://127.0.0.1:3000/:path*`,
        },
      ],
    }
  },
}
