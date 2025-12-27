-- Update all news content with images

-- lhala-doctor (already done)

-- artmake
UPDATE campaigns SET content = '<div class="news-content-images">
<img src="/images/news/content/artmake/img01.jpg" alt="アートメイク" style="max-width:100%;height:auto;" />
<img src="/images/news/content/artmake/img02.jpg" alt="アートメイク" style="max-width:100%;height:auto;" />
<img src="/images/news/content/artmake/img03.jpg" alt="アートメイク" style="max-width:100%;height:auto;" />
<img src="/images/news/content/artmake/img04.jpg" alt="アートメイク" style="max-width:100%;height:auto;" />
<img src="/images/news/content/artmake/img05.jpg" alt="アートメイク" style="max-width:100%;height:auto;" />
<img src="/images/news/content/artmake/img06.jpg" alt="アートメイク" style="max-width:100%;height:auto;" />
<img src="/images/news/content/artmake/img07.jpg" alt="アートメイク" style="max-width:100%;height:auto;" />
<p>アートメイクにご興味をお持ちの方は下記公式Line・お電話から問い合わせください</p>
</div>' WHERE slug = 'artmake';

-- friend
UPDATE campaigns SET content = '<div class="news-content-images">
<img src="/images/news/content/friend/img01.png" alt="友だち紹介キャンペーン" style="max-width:100%;height:auto;" />
<img src="/images/news/content/friend/img02.png" alt="友だち紹介キャンペーン" style="max-width:100%;height:auto;" />
</div>' WHERE slug = 'friend';

-- botox
UPDATE campaigns SET content = '<div class="news-content-images">
<img src="/images/news/content/botox/img01.jpg" alt="ボトックス" style="max-width:100%;height:auto;" />
<img src="/images/news/content/botox/img02.jpg" alt="ボトックス" style="max-width:100%;height:auto;" />
</div>' WHERE slug = 'botox';

-- eve-v-muse (no detailed content - banner only)
UPDATE campaigns SET content = '<p>最新の肌診断機「Eve V MUSE」を導入しました。詳しくはスタッフにお尋ねください。</p>' WHERE slug = 'eve-v-muse';

-- holidaycampaign (no detailed content - banner only)  
UPDATE campaigns SET content = '<p>ホリデーキャンペーン実施中！詳しくはスタッフにお尋ねください。</p>' WHERE slug = 'holidaycampaign';

-- tribyu (no detailed content)
UPDATE campaigns SET content = '<p>トリビューに当院が掲載されました。</p>' WHERE slug = 'tribyu';

-- ito (no detailed content)
UPDATE campaigns SET content = '<p>糸リフトの施術を開始しました。詳しくはスタッフにお尋ねください。</p>' WHERE slug = 'ito';

-- shibouyoukai (no detailed content)
UPDATE campaigns SET content = '<p>脂肪溶解注射を導入しました。詳しくはスタッフにお尋ねください。</p>' WHERE slug = 'shibouyoukai';

-- hyaluronicacid (no detailed content)
UPDATE campaigns SET content = '<p>ヒアルロン酸注入を開始しました。詳しくはスタッフにお尋ねください。</p>' WHERE slug = 'hyaluronicacid';

-- picotoning (no detailed content)
UPDATE campaigns SET content = '<p>ピコトーニングスタートしました♡ 詳しくはスタッフにお尋ねください。</p>' WHERE slug = 'picotoning';

-- ellisyssense (no detailed content)
UPDATE campaigns SET content = '<p>ポテンツァの進化版！！エリシスセンスを導入しました。詳しくはスタッフにお尋ねください。</p>' WHERE slug = 'ellisyssense';

-- medicaldiet (no detailed content)
UPDATE campaigns SET content = '<p>リベルサスとマンジャロの提供をはじめました。詳しくはスタッフにお尋ねください。</p>' WHERE slug = 'medicaldiet';

-- rybelsus (no detailed content)
UPDATE campaigns SET content = '<p>リベルサスのご紹介。詳しくはスタッフにお尋ねください。</p>' WHERE slug = 'rybelsus';

