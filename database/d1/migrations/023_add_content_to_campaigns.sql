-- Add content and image_url columns to campaigns table for detailed news content

ALTER TABLE campaigns ADD COLUMN content TEXT;
ALTER TABLE campaigns ADD COLUMN image_url TEXT;

-- Create index for slug lookups
CREATE INDEX IF NOT EXISTS idx_campaigns_slug ON campaigns(slug);

