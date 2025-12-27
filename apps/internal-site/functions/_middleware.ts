// Basic認証ミドルウェア
// Cloudflare Pages Functions用

interface Env {
  BASIC_AUTH_USER?: string;
  BASIC_AUTH_PASSWORD?: string;
}

const REALM = 'Ledian Clinic 管理サイト';

// デフォルトの認証情報（本番では環境変数で上書き）
const DEFAULT_USER = 'ledian';
const DEFAULT_PASSWORD = 'clinic2024!';

export const onRequest: PagesFunction<Env> = async (context) => {
  const { request, env, next } = context;
  
  // 認証情報を取得（環境変数があればそれを使用、なければデフォルト）
  const validUser = env.BASIC_AUTH_USER || DEFAULT_USER;
  const validPassword = env.BASIC_AUTH_PASSWORD || DEFAULT_PASSWORD;
  
  // APIへのリクエストは認証をスキップ（内部通信用）
  const url = new URL(request.url);
  if (url.pathname.startsWith('/api/') && request.headers.get('X-Internal-Request') === 'true') {
    return next();
  }
  
  // Authorizationヘッダーを確認
  const authorization = request.headers.get('Authorization');
  
  if (!authorization) {
    return unauthorizedResponse();
  }
  
  // Basic認証のデコード
  const [scheme, encoded] = authorization.split(' ');
  
  if (scheme !== 'Basic' || !encoded) {
    return unauthorizedResponse();
  }
  
  try {
    const decoded = atob(encoded);
    const [user, password] = decoded.split(':');
    
    // 認証チェック
    if (user === validUser && password === validPassword) {
      return next();
    }
  } catch (e) {
    // デコードエラー
  }
  
  return unauthorizedResponse();
};

function unauthorizedResponse(): Response {
  return new Response('認証が必要です', {
    status: 401,
    headers: {
      'WWW-Authenticate': `Basic realm="${REALM}", charset="UTF-8"`,
      'Content-Type': 'text/plain; charset=UTF-8',
    },
  });
}

