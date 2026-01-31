# 7-Day AI Challenge v2.0

MachineMind's viral 7-day challenge landing page with full email capture, referral system, and business lead generation.

## Features

- ✅ Email capture with Supabase backend
- ✅ Real-time signup counter (social proof)
- ✅ Countdown timer to challenge start
- ✅ Expandable challenge cards
- ✅ 5 FREE websites giveaway section
- ✅ Referral tracking system
- ✅ Share buttons with pre-written copy
- ✅ Cal.com booking integration
- ✅ Instagram @showowt link
- ✅ "Want this for your business?" CTA
- ✅ OG meta tags for social sharing
- ✅ Mobile responsive design

## Setup

### 1. Install Dependencies

```bash
npm install
```

### 2. Set Up Supabase

1. Create a new project at [supabase.com](https://supabase.com)
2. Go to SQL Editor and run the contents of `supabase/schema.sql`
3. Copy your project URL and anon key from Settings > API

### 3. Configure Environment Variables

Create `.env.local`:

```env
NEXT_PUBLIC_SUPABASE_URL=https://your-project.supabase.co
NEXT_PUBLIC_SUPABASE_ANON_KEY=your-anon-key-here
NEXT_PUBLIC_SITE_URL=https://your-domain.vercel.app
```

### 4. Run Locally

```bash
npm run dev
```

### 5. Deploy to Vercel

```bash
vercel
```

Or push to GitHub and connect to Vercel for auto-deployment.

## Supabase Tables

### challenge_subscribers
- Stores email signups
- Tracks referral codes and counts
- Records signup source

### website_pitches
- Stores submissions for the 5 free websites giveaway
- Tracks pitch status (pending/selected/rejected)

## Customization

### Challenge Dates
Update the challenge dates in `app/page.tsx`:
```typescript
const challengeStart = new Date('2026-02-03T00:00:00')
```

### Social Links
- Instagram: Update `@showowt` references
- Cal.com: Update `https://cal.com/machine-mind/discovery`

### Social Proof Number
Starting subscriber count in `app/page.tsx`:
```typescript
const [subscriberCount, setSubscriberCount] = useState(523)
```

## Structure

```
7-day-v2/
├── app/
│   ├── globals.css      # Styles & animations
│   ├── layout.tsx       # Metadata & layout
│   └── page.tsx         # Main page component
├── lib/
│   └── supabase.ts      # Supabase client
├── supabase/
│   └── schema.sql       # Database schema
├── public/
│   └── og-image.png     # Social share image
└── .env.example         # Environment template
```

## License

MachineMind Proprietary
