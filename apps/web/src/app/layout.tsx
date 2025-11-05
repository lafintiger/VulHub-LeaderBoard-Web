import type { Metadata } from 'next';
import { Inter } from 'next/font/google';
import { QueryProvider } from '../lib/data/QueryProvider';
import { AuthProvider } from '../lib/auth/context';
import { NotificationProvider } from '../lib/notifications/context';
import { ErrorBoundary } from '../components/common/ErrorBoundary';
import { ToastContainer } from '../components/notifications/ToastContainer';
import { SkipLink } from '../components/accessibility/SkipLink';
import { OrganizationSchema, WebSiteSchema } from '../components/seo/StructuredData';
import './matrix-unified.css';
import './styles/accessibility.css';
import './styles/responsive.css';

export const viewport = {
  width: 'device-width',
  initialScale: 1,
  maximumScale: 1,
}


const inter = Inter({ subsets: ['latin'] });

const siteUrl = process.env.NEXT_PUBLIC_SITE_URL || 'http://localhost:3000';

export const metadata: Metadata = {
  metadataBase: new URL(siteUrl),
  title: {
    default: 'VulHub Leaderboard',
    template: '%s | VulHub Leaderboard',
  },
  description: 'A gamified platform for cybersecurity students to practice, compete, and grow.',
  keywords: ['cybersecurity', 'education', 'leaderboard', 'vulhub', 'competition'],
  authors: [{ name: 'CSUSB Cybersecurity Program' }],
  creator: 'CSUSB Cybersecurity Program',
  publisher: 'CSUSB Cybersecurity Program',
  viewport: 'width=device-width, initial-scale=1',
  openGraph: {
    type: 'website',
    locale: 'en_US',
    url: '/',
    siteName: 'VulHub Leaderboard',
    title: 'VulHub Leaderboard',
    description: 'A gamified platform for cybersecurity students to practice, compete, and grow.',
    images: [
      {
        url: '/og-image.png',
        width: 1200,
        height: 630,
        alt: 'VulHub Leaderboard',
      },
    ],
  },
  twitter: {
    card: 'summary_large_image',
    title: 'VulHub Leaderboard',
    description: 'A gamified platform for cybersecurity students to practice, compete, and grow.',
    images: ['/og-image.png'],
  },
  robots: {
    index: true,
    follow: true,
    googleBot: {
      index: true,
      follow: true,
      'max-video-preview': -1,
      'max-image-preview': 'large',
      'max-snippet': -1,
    },
  },
};

export default function RootLayout({
  children,
}: {
  children: React.ReactNode;
}) {
  return (
    <html lang="en" suppressHydrationWarning>
      <head>
        <meta charSet="utf-8" />
        <meta name="viewport" content="width=device-width, initial-scale=1" />
        
        {/* DNS Prefetch for API */}
        <link rel="dns-prefetch" href={process.env.NEXT_PUBLIC_API_URL || 'http://localhost:4000'} />
        
        {/* Preconnect to API for faster requests */}
        <link rel="preconnect" href={process.env.NEXT_PUBLIC_API_URL || 'http://localhost:4000'} crossOrigin="anonymous" />
        
        {/* Resource hints for fonts */}
        <link rel="preconnect" href="https://fonts.googleapis.com" />
        <link rel="preconnect" href="https://fonts.gstatic.com" crossOrigin="anonymous" />
      </head>
      <body className={inter.className} data-app-shell data-theme="matrix">
        <OrganizationSchema siteUrl={siteUrl} />
        <WebSiteSchema siteUrl={siteUrl} />
        <SkipLink targetId="main-content" label="Skip to main content" />
        <QueryProvider>
          <AuthProvider>
            <NotificationProvider>
              <ErrorBoundary>
                <main id="main-content" tabIndex={-1} role="main">
                  {children}
                </main>
              </ErrorBoundary>
              <ToastContainer />
            </NotificationProvider>
          </AuthProvider>
        </QueryProvider>
      </body>
    </html>
  );
}
