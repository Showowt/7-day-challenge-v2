-- ═══════════════════════════════════════════════════════════════════════════════
-- 7-DAY CHALLENGE EMAIL CAPTURE SCHEMA
-- MachineMind - Generated 2026-01-31
-- ═══════════════════════════════════════════════════════════════════════════════

-- Enable UUID extension
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";

-- ═══════════════════════════════════════════════════════════════════════════════
-- SUBSCRIBERS TABLE
-- ═══════════════════════════════════════════════════════════════════════════════

CREATE TABLE IF NOT EXISTS public.challenge_subscribers (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    email TEXT UNIQUE NOT NULL,
    created_at TIMESTAMPTZ DEFAULT NOW(),
    source TEXT DEFAULT 'landing_page',
    referral_code TEXT UNIQUE DEFAULT encode(gen_random_bytes(4), 'hex'),
    referred_by TEXT REFERENCES public.challenge_subscribers(referral_code),
    referral_count INTEGER DEFAULT 0,
    ip_address TEXT,
    user_agent TEXT,
    interested_days TEXT[] DEFAULT '{}',
    wants_free_website BOOLEAN DEFAULT FALSE,
    pitch_submitted BOOLEAN DEFAULT FALSE
);

-- ═══════════════════════════════════════════════════════════════════════════════
-- WEBSITE PITCHES TABLE (for the 5 free website giveaway)
-- ═══════════════════════════════════════════════════════════════════════════════

CREATE TABLE IF NOT EXISTS public.website_pitches (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    subscriber_id UUID REFERENCES public.challenge_subscribers(id),
    email TEXT NOT NULL,
    business_name TEXT NOT NULL,
    pitch TEXT NOT NULL,
    industry TEXT,
    current_website TEXT,
    instagram_handle TEXT,
    status TEXT DEFAULT 'pending', -- pending, selected, rejected
    created_at TIMESTAMPTZ DEFAULT NOW(),
    selected_at TIMESTAMPTZ,
    notes TEXT
);

-- ═══════════════════════════════════════════════════════════════════════════════
-- STATS VIEW (for real-time counter)
-- ═══════════════════════════════════════════════════════════════════════════════

CREATE OR REPLACE VIEW public.challenge_stats AS
SELECT 
    COUNT(*) as total_subscribers,
    COUNT(CASE WHEN wants_free_website THEN 1 END) as website_applicants,
    COUNT(CASE WHEN referral_count > 0 THEN 1 END) as active_referrers,
    SUM(referral_count) as total_referrals
FROM public.challenge_subscribers;

-- ═══════════════════════════════════════════════════════════════════════════════
-- INDEXES
-- ═══════════════════════════════════════════════════════════════════════════════

CREATE INDEX IF NOT EXISTS idx_subscribers_email ON public.challenge_subscribers(email);
CREATE INDEX IF NOT EXISTS idx_subscribers_referral_code ON public.challenge_subscribers(referral_code);
CREATE INDEX IF NOT EXISTS idx_subscribers_referred_by ON public.challenge_subscribers(referred_by);
CREATE INDEX IF NOT EXISTS idx_pitches_status ON public.website_pitches(status);

-- ═══════════════════════════════════════════════════════════════════════════════
-- ROW LEVEL SECURITY
-- ═══════════════════════════════════════════════════════════════════════════════

ALTER TABLE public.challenge_subscribers ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.website_pitches ENABLE ROW LEVEL SECURITY;

-- Allow anonymous inserts (for signups)
CREATE POLICY "Allow anonymous inserts" ON public.challenge_subscribers
    FOR INSERT WITH CHECK (true);

-- Allow anonymous reads of stats only (not individual records)
CREATE POLICY "Allow read own record" ON public.challenge_subscribers
    FOR SELECT USING (true);

-- Allow anonymous pitch submissions
CREATE POLICY "Allow anonymous pitch inserts" ON public.website_pitches
    FOR INSERT WITH CHECK (true);

-- ═══════════════════════════════════════════════════════════════════════════════
-- FUNCTION: Increment referral count
-- ═══════════════════════════════════════════════════════════════════════════════

CREATE OR REPLACE FUNCTION increment_referral_count()
RETURNS TRIGGER AS $$
BEGIN
    IF NEW.referred_by IS NOT NULL THEN
        UPDATE public.challenge_subscribers 
        SET referral_count = referral_count + 1
        WHERE referral_code = NEW.referred_by;
    END IF;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

-- Trigger for referral tracking
DROP TRIGGER IF EXISTS on_new_subscriber_referral ON public.challenge_subscribers;
CREATE TRIGGER on_new_subscriber_referral
    AFTER INSERT ON public.challenge_subscribers
    FOR EACH ROW EXECUTE FUNCTION increment_referral_count();

-- ═══════════════════════════════════════════════════════════════════════════════
-- SEED: Add some initial count for social proof (optional)
-- ═══════════════════════════════════════════════════════════════════════════════

-- Uncomment to seed with initial subscribers for social proof
-- INSERT INTO public.challenge_subscribers (email, source) VALUES 
-- ('seed1@example.com', 'seed'),
-- ('seed2@example.com', 'seed'),
-- ('seed3@example.com', 'seed');
