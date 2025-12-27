-- Update remaining news content with extracted HTML and local image paths

-- holidaycampaign
UPDATE campaigns SET 
  content = '<div class="news-content-images">
<img src="/images/news/content/holidaycampaign/img01.jpg" alt="Holiday Campaign" style="width: 100%; max-width: 100%;" />
<img src="/images/news/content/holidaycampaign/img02.jpg" alt="Holiday Campaign 詳細" style="width: 100%; max-width: 100%;" />
</div>'
WHERE slug = 'holidaycampaign';

-- ito (糸リフト)
UPDATE campaigns SET 
  content = '<div class="news-content-images">
<img src="/images/news/content/ito/img01.jpg" alt="糸リフト" style="width: 100%; max-width: 100%;" />
<img src="/images/news/content/ito/img02.jpg" alt="糸リフト詳細1" style="width: 100%; max-width: 100%;" />
<img src="/images/news/content/ito/img03.jpg" alt="糸リフト詳細2" style="width: 100%; max-width: 100%;" />
<img src="/images/news/content/ito/img04.jpg" alt="糸リフト詳細3" style="width: 100%; max-width: 100%;" />
</div>
<p style="text-align: center; margin-top: 20px;">
<a href="https://reservation.medical-force.com/c/cb1fa0d3fc8a41f3943b2c61027e5284" target="_blank" class="btn btn-primary">WEB予約はこちら</a>
</p>'
WHERE slug = 'ito';

-- shibouyoukai (脂肪溶解注射)
UPDATE campaigns SET 
  content = '<div class="news-content-images">
<img src="/images/news/content/shibouyoukai/img01.jpg" alt="脂肪溶解注射" style="width: 100%; max-width: 100%;" />
</div>'
WHERE slug = 'shibouyoukai';

-- hyaluronicacid (ヒアルロン酸注入)
UPDATE campaigns SET 
  content = '<div class="news-content-images">
<img src="/images/news/content/hyaluronicacid/img01.jpg" alt="ヒアルロン酸注入" style="width: 100%; max-width: 100%;" />
</div>'
WHERE slug = 'hyaluronicacid';

-- picotoning
UPDATE campaigns SET 
  content = '<div class="news-content-images">
<img src="/images/news/content/picotoning/img01.jpg" alt="ピコトーニング" style="width: 100%; max-width: 100%;" />
<img src="/images/news/content/picotoning/img02.jpg" alt="ピコトーニング詳細" style="width: 100%; max-width: 100%;" />
</div>'
WHERE slug = 'picotoning';

-- ellisyssense (エリシスセンス)
UPDATE campaigns SET 
  content = '<div class="news-content-images">
<img src="/images/news/content/ellisyssense/img01.jpg" alt="エリシスセンス" style="width: 100%; max-width: 100%;" />
<img src="/images/news/content/ellisyssense/img02.jpg" alt="エリシスセンス詳細1" style="width: 100%; max-width: 100%;" />
<img src="/images/news/content/ellisyssense/img03.jpg" alt="エリシスセンス詳細2" style="width: 100%; max-width: 100%;" />
<img src="/images/news/content/ellisyssense/img04.jpg" alt="エリシスセンス詳細3" style="width: 100%; max-width: 100%;" />
</div>'
WHERE slug = 'ellisyssense';

-- medicaldiet (メディカルダイエット)
UPDATE campaigns SET 
  content = '<div class="news-content-images">
<img src="/images/news/content/medicaldiet/img01.png" alt="メディカルダイエット" style="width: 100%; max-width: 100%;" />
<img src="/images/news/content/medicaldiet/img02.png" alt="メディカルダイエット詳細1" style="width: 100%; max-width: 100%;" />
<img src="/images/news/content/medicaldiet/img03.png" alt="メディカルダイエット詳細2" style="width: 100%; max-width: 100%;" />
</div>'
WHERE slug = 'medicaldiet';

-- rybelsus (リベルサス)
UPDATE campaigns SET 
  content = '<div class="news-content-images">
<img src="/images/news/content/rybelsus/img01.jpg" alt="リベルサス" style="width: 100%; max-width: 100%;" />
<img src="/images/news/content/rybelsus/img02.jpg" alt="リベルサス詳細1" style="width: 100%; max-width: 100%;" />
<img src="/images/news/content/rybelsus/img03.jpg" alt="リベルサス詳細2" style="width: 100%; max-width: 100%;" />
<img src="/images/news/content/rybelsus/img04.jpg" alt="リベルサス詳細3" style="width: 100%; max-width: 100%;" />
</div>'
WHERE slug = 'rybelsus';

-- eve-v-muse (肌診断機 Eve V MUSE)
UPDATE campaigns SET 
  content = '<div class="news-content-images">
<img src="/images/news/content/eve-v-muse/img01.jpg" alt="Eve V MUSE" style="width: 100%; max-width: 100%;" />
<img src="/images/news/content/eve-v-muse/img02.jpg" alt="Eve V MUSE詳細1" style="width: 100%; max-width: 100%;" />
<img src="/images/news/content/eve-v-muse/img03.jpg" alt="Eve V MUSE詳細2" style="width: 100%; max-width: 100%;" />
</div>'
WHERE slug = 'eve-v-muse';

