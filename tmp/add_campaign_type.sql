-- Add campaign_type column if not exists
ALTER TABLE campaigns ADD COLUMN campaign_type VARCHAR(20) DEFAULT 'discount';

-- Add content column if not exists  
ALTER TABLE campaigns ADD COLUMN content TEXT;

