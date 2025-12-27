export const SITE_TITLE = 'Ledian Clinic（レディアンクリニック六本木）美容内科、美容皮膚科';
export const DEFAULT_DESCRIPTION =
  'Ledian Clinic（レディアンクリニック六本木）は、六本木駅徒歩1分の美容内科・美容皮膚科です。最新美容機器と通いやすい価格で、続けられる美容習慣を。';
export const DEFAULT_OG_IMAGE = '/images/og-image.png';
export const PRODUCTION_ORIGIN = 'https://ledianclinic.jp';

export function buildFullTitle(pageTitle: string): string {
  return pageTitle === 'ホーム' ? SITE_TITLE : `${pageTitle} | ${SITE_TITLE}`;
}
