import { defineMiddleware } from 'astro:middleware';

const REALM = 'Ledian Clinic 管理サイト';

// 認証情報（本番では環境変数で上書き推奨）
const VALID_USER = 'ledian';
const VALID_PASSWORD = 'clinic2024!';

export const onRequest = defineMiddleware(async (context, next) => {
  const { request } = context;
  const url = new URL(request.url);
  
  // 静的アセットはスキップ
  if (
    url.pathname.startsWith('/_astro/') ||
    url.pathname.startsWith('/images/') ||
    url.pathname.endsWith('.css') ||
    url.pathname.endsWith('.js') ||
    url.pathname.endsWith('.png') ||
    url.pathname.endsWith('.svg') ||
    url.pathname.endsWith('.ico')
  ) {
    return next();
  }
  
  // Authorizationヘッダーを確認
  const authorization = request.headers.get('Authorization');
  
  if (!authorization) {
    return new Response('認証が必要です', {
      status: 401,
      headers: {
        'WWW-Authenticate': `Basic realm="${REALM}", charset="UTF-8"`,
        'Content-Type': 'text/plain; charset=UTF-8',
      },
    });
  }
  
  // Basic認証のデコード
  const [scheme, encoded] = authorization.split(' ');
  
  if (scheme !== 'Basic' || !encoded) {
    return new Response('認証が必要です', {
      status: 401,
      headers: {
        'WWW-Authenticate': `Basic realm="${REALM}", charset="UTF-8"`,
        'Content-Type': 'text/plain; charset=UTF-8',
      },
    });
  }
  
  try {
    const decoded = atob(encoded);
    const [user, password] = decoded.split(':');
    
    // 認証チェック
    if (user === VALID_USER && password === VALID_PASSWORD) {
      return next();
    }
  } catch (e) {
    // デコードエラー
  }
  
  return new Response('認証が必要です', {
    status: 401,
    headers: {
      'WWW-Authenticate': `Basic realm="${REALM}", charset="UTF-8"`,
      'Content-Type': 'text/plain; charset=UTF-8',
    },
  });
});

