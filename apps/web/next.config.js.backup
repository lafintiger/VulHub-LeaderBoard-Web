/** @type {import('next').NextConfig} */
const nextConfig = {
  // Production optimizations
  reactStrictMode: true,
  swcMinify: true,
  
  // Compression
  compress: true,
  
  // Output configuration (standalone for Docker/K8s)
  // output: 'standalone', // Disabled due to Windows symlink issues
  
  // Transpile workspace packages
  // transpilePackages: ['@vulhub/ui', '@vulhub/schema', '@vulhub/utils'],
  
  // TypeScript configuration
  typescript: {
    // ⚠️ Set to false in production for better optimization
    // Currently true for development speed - should be false for production
    ignoreBuildErrors: process.env.NODE_ENV === 'production' ? false : true,
  },
  
  // ESLint configuration
  eslint: {
    // ⚠️ Set to false in production for better code quality
    // Currently true for development speed - should be false for production
    ignoreDuringBuilds: process.env.NODE_ENV === 'production' ? false : true,
  },
  
  // Image optimization
  images: {
    domains: process.env.NEXT_PUBLIC_IMAGE_DOMAINS 
      ? process.env.NEXT_PUBLIC_IMAGE_DOMAINS.split(',')
      : [],
    formats: ['image/avif', 'image/webp'],
    minimumCacheTTL: 60,
  },
  
  // Performance optimizations
  poweredByHeader: false,
  
  // Headers for caching and security
  async headers() {
    return [
      {
        source: '/:path*',
        headers: [
          {
            key: 'X-DNS-Prefetch-Control',
            value: 'on'
          },
          {
            key: 'X-Content-Type-Options',
            value: 'nosniff'
          },
          {
            key: 'X-Frame-Options',
            value: 'DENY'
          },
          {
            key: 'X-XSS-Protection',
            value: '1; mode=block'
          },
          {
            key: 'Referrer-Policy',
            value: 'strict-origin-when-cross-origin'
          }
        ],
      },
      {
        // Cache static assets
        source: '/:all*(svg|jpg|jpeg|png|gif|ico|webp|woff|woff2|ttf|eot)',
        headers: [
          {
            key: 'Cache-Control',
            value: 'public, max-age=31536000, immutable',
          },
        ],
      },
      {
        // Cache _next static files
        source: '/_next/static/:path*',
        headers: [
          {
            key: 'Cache-Control',
            value: 'public, max-age=31536000, immutable',
          },
        ],
      },
    ];
  },
}

module.exports = nextConfig
