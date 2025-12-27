-- Link Eve V Muse service_content to its subcategory
UPDATE service_contents 
SET subcategory_id = 'b8e4bd8a-8517-494a-a14d-336bb36fcf93'
WHERE id = '47c4f65f';

-- Verify the update
SELECT id, name_ja, slug, subcategory_id, is_published 
FROM service_contents 
WHERE slug = 'eve-v-muse';

