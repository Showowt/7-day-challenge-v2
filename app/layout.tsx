import type { Metadata } from 'next'
import './globals.css'

export const metadata: Metadata = {
  title: '7 Days. 7 Free AI Tools. | MachineMind Challenge',
  description: 'Every day for 7 days, I\'m building a free AI tool for a different audience. Find your day. Get your tool. No catch.',
  keywords: ['AI tools', 'free AI', 'automation', 'MachineMind', 'business tools', 'content calendar', 'brand builder'],
  authors: [{ name: 'MachineMind', url: 'https://machinemindconsulting.com' }],
  creator: 'MachineMind',
  openGraph: {
    type: 'website',
    locale: 'en_US',
    url: 'https://7-day-challenge-landing.vercel.app',
    siteName: '7-Day AI Challenge',
    title: '7 Days. 7 Free AI Tools. | MachineMind',
    description: 'Every day for 7 days, I\'m building a free AI tool for a different audience. Find your day. Get your tool.',
    images: [
      {
        url: '/og-image.png',
        width: 1200,
        height: 630,
        alt: '7 Days 7 Free AI Tools - MachineMind Challenge',
      },
    ],
  },
  twitter: {
    card: 'summary_large_image',
    title: '7 Days. 7 Free AI Tools. | MachineMind',
    description: 'Every day for 7 days, I\'m building a free AI tool for a different audience.',
    images: ['/og-image.png'],
    creator: '@showowt',
  },
  robots: {
    index: true,
    follow: true,
  },
}

export default function RootLayout({
  children,
}: {
  children: React.ReactNode
}) {
  return (
    <html lang="en">
      <head>
        <link rel="icon" href="/favicon.ico" />
        <meta name="theme-color" content="#0a0a0a" />
      </head>
      <body className="bg-mesh noise-overlay">
        {children}
      </body>
    </html>
  )
}
