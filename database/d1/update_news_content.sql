-- Update news/campaign content and image URLs
-- Based on content extracted from production site

-- Cancel Policy News
UPDATE campaigns SET 
  image_url = '/images/news/cancel.jpg',
  content = '<p>日頃より、レディアンクリニックをご愛顧いただき、心より感謝申し上げます。</p>
<p>当クリニックでは、これまでも、キャンセルポリシーを設けさせていただいておりましたが、お客様のご都合を優先して柔軟に対応してまいりました。</p>
<p>この度、全ての患者様にとって公平なご予約機会を確保し、クリニック全体の運営をより円滑に進めていくために、<strong>2025年6月1日のご予約分</strong>より、キャンセルポリシーを一部改定し、より丁寧な運用を心がけていくこととなりました。</p>
<hr>
<p><strong>【ご確認いただきたいキャンセルポリシーのポイント】</strong></p>
<p>★ ご予約の変更・キャンセル： お手数をおかけしますが<strong>【ご予約日時の24時間前まで】</strong>にご連絡をお願いいたします。</p>
<p>★ ご連絡方法： お電話、またはLINE公式アカウント等、当クリニック指定の予約システムよりお知らせください。</p>
<p>★ 大変心苦しいお願いではございますが、原則として、以下のキャンセル料を次回ご来院の際にお願いしております。</p>
<p><strong>医師施術の場合：ご予約施術料金の50％</strong></p>
<p><strong>その他の予約(ナース施術・処方など)：3,300円</strong></p>
<p>★ 無断キャンセル・度重なる直前変更をされるお客様は誠に不本意ながら、<strong>今後のご予約をお受けできなくなる場合がございます。</strong></p>
<p>詳細につきましては、下記のキャンセルポリシーページをご一読いただきますようお願いいたします。</p>
<p><a href="/cancel/">Ledian Clinic キャンセルポリシー</a></p>
<p>今回の運用変更は、患者様皆様がより快適に、そして安心して当クリニックのサービスをご利用いただくために、私たちなりに考えた結果でございます。ご不便をおかけすることもあるかと存じますが、何卒ご理解いただき、今後とも変わらぬご愛顧を賜りますよう、重ねてお願い申し上げます。</p>
<p>ご不明な点がございましたら、お気軽にクリニックまでお問い合わせください。</p>
<p>レディアンクリニック</p>'
WHERE slug = 'cancel';

-- Eve V MUSE
UPDATE campaigns SET 
  image_url = '/images/news/eve-v-muse.jpg'
WHERE slug = 'eve-v-muse';

-- Friend Referral Campaign
UPDATE campaigns SET 
  image_url = '/images/news/friend.png'
WHERE slug = 'friend';

-- Holiday Campaign
UPDATE campaigns SET 
  image_url = '/images/news/holidaycampaign.jpg'
WHERE slug = 'holidaycampaign';

-- Artmake
UPDATE campaigns SET 
  image_url = '/images/news/artmake.jpg'
WHERE slug = 'artmake';

-- Tribyu
UPDATE campaigns SET 
  image_url = '/images/news/tribyu.jpg'
WHERE slug = 'tribyu';

-- LHALA Doctor
UPDATE campaigns SET 
  image_url = '/images/news/lhala-doctor.jpg'
WHERE slug = 'lhala-doctor';

-- Ito (Thread Lift)
UPDATE campaigns SET 
  image_url = '/images/news/ito.jpg'
WHERE slug = 'ito';

-- Shibouyoukai (Fat Dissolving)
UPDATE campaigns SET 
  image_url = '/images/news/shibouyoukai.jpg'
WHERE slug = 'shibouyoukai';

-- Hyaluronic Acid
UPDATE campaigns SET 
  image_url = '/images/news/hyaluronicacid.jpg'
WHERE slug = 'hyaluronicacid';

-- Pico Toning
UPDATE campaigns SET 
  image_url = '/images/news/picotoning.jpg'
WHERE slug = 'picotoning';

-- Botox
UPDATE campaigns SET 
  image_url = '/images/news/botox.jpg'
WHERE slug = 'botox';

-- Ellisys Sense
UPDATE campaigns SET 
  image_url = '/images/news/ellisyssense.jpg'
WHERE slug = 'ellisyssense';

-- Medical Diet
UPDATE campaigns SET 
  image_url = '/images/news/medicaldiet.jpg'
WHERE slug = 'medicaldiet';

-- Rybelsus
UPDATE campaigns SET 
  image_url = '/images/news/rybelsus.jpg'
WHERE slug = 'rybelsus';

