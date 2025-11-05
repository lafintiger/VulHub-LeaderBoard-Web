import { NextResponse, NextRequest } from 'next/server';
import crypto from 'crypto';

// Check if in production
const isProduction = process.env.NODE_ENV === 'production';

/**
 * Generate CSP nonce for inline scripts/styles
 */
function generateNonce(): string {
  return crypto.randomBytes(16).toString('base64');
}

/**
 * Build Content Security Policy
 */
function buildCSP(nonce?: string): string {
  const apiUrl = process.env.NEXT_PUBLIC_API_URL || 'http://localhost:4000';
  const apiDomain = new URL(apiUrl).origin;

  if (isProduction) {
    // PRODUCTION CSP - Strict security
    return [
      "default-src 'self'",
      nonce 
        ? `script-src 'self' 'nonce-${nonce}' 'strict-dynamic'`
        : "script-src 'self'",
      nonce
        ? `style-src 'self' 'nonce-${nonce}' https://fonts.googleapis.com`
        : "style-src 'self' https://fonts.googleapis.com",
      "img-src 'self' data: https:",
      "font-src 'self' https://fonts.gstatic.com data:",
      `connect-src 'self' ${apiDomain} wss: ws:`,
      "frame-ancestors 'none'",
      "form-action 'self'",
      "base-uri 'self'",
      "object-src 'none'",
      "media-src 'self'",
      "manifest-src 'self'",
      "worker-src 'self' blob:",
      "upgrade-insecure-requests",
    ].join('; ');
  } else {
    // DEVELOPMENT CSP - More permissive for hot reload, etc.
    return [
      "default-src 'self' 'unsafe-inline' 'unsafe-eval' data: blob:",
      "base-uri 'self'",
      "font-src 'self' https://fonts.gstatic.com data:",
      "img-src 'self' data: blob: https:",
      "script-src 'self' 'unsafe-inline' 'unsafe-eval'",
      "style-src 'self' 'unsafe-inline' https://fonts.googleapis.com",
      "connect-src 'self' http://localhost:* ws://localhost:*",
      "frame-ancestors 'none'",
      "object-src 'none'",
    ].join('; ');
  }
}

export function middleware(req: NextRequest) {
  const res = NextResponse.next();

  // Generate CSP nonce for production
  const nonce = isProduction ? generateNonce() : undefined;

  // === SECURITY HEADERS ===

  // Prevent MIME type sniffing
  res.headers.set('X-Content-Type-Options', 'nosniff');

  // Prevent clickjacking
  res.headers.set('X-Frame-Options', 'DENY');

  // Control referrer information
  res.headers.set('Referrer-Policy', 'strict-origin-when-cross-origin');

  // Disable DNS prefetching
  res.headers.set('X-DNS-Prefetch-Control', 'off');

  // Disable FLoC tracking
  res.headers.set('Permissions-Policy', 'interest-cohort=()');

  // Content Security Policy
  res.headers.set('Content-Security-Policy', buildCSP(nonce));

  // Enable HSTS for HTTPS
  if (req.nextUrl.protocol === 'https:' || isProduction) {
    res.headers.set(
      'Strict-Transport-Security',
      'max-age=31536000; includeSubDomains; preload'
    );
  }

  // Store nonce for use in HTML (if needed)
  if (nonce) {
    res.headers.set('X-CSP-Nonce', nonce);
  }

  return res;
}

export const config = {
  matcher: [
    /*
     * Match all request paths except:
     * - _next/static (static files)
     * - _next/image (image optimization)
     * - favicon.ico, robots.txt, sitemap.xml (public files)
     */
    '/((?!_next/static|_next/image|favicon.ico|robots.txt|sitemap.xml).*)',
  ],
};

// Force middleware to run in Node.js runtime (not Edge)
export const config = {
  runtime: 'nodejs',
  unstable_allowDynamic: [
    '/node_modules/**',
  ],
}
