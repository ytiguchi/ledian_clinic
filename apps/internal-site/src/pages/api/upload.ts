import type { APIRoute } from 'astro';
import { getDB } from '../../lib/db';

export const prerender = false;

export const POST: APIRoute = async ({ locals, request }) => {
  if (!locals?.runtime?.env) {
    return new Response(JSON.stringify({ error: 'Environment not available' }), {
      status: 500,
      headers: { 'Content-Type': 'application/json' },
    });
  }

  try {
    const formData = await request.formData();
    const file = formData.get('file') as File;
    const type = formData.get('type') as string || 'before-after'; // before-after, treatment, etc.

    if (!file) {
      return new Response(JSON.stringify({ error: 'No file provided' }), {
        status: 400,
        headers: { 'Content-Type': 'application/json' },
      });
    }

    // ファイルサイズチェック（10MB制限）
    const MAX_FILE_SIZE = 10 * 1024 * 1024; // 10MB
    if (file.size > MAX_FILE_SIZE) {
      return new Response(JSON.stringify({ error: 'File size exceeds 10MB limit' }), {
        status: 400,
        headers: { 'Content-Type': 'application/json' },
      });
    }

    // ファイルタイプチェック
    const allowedTypes = [
      'image/jpeg', 'image/png', 'image/webp', 'image/gif',
      'application/pdf',
      'application/vnd.openxmlformats-officedocument.wordprocessingml.document',
      'application/vnd.openxmlformats-officedocument.presentationml.presentation'
    ];
    if (!allowedTypes.includes(file.type)) {
      return new Response(JSON.stringify({ error: 'Invalid file type. Only images, PDF, DOCX, and PPTX are allowed' }), {
        status: 400,
        headers: { 'Content-Type': 'application/json' },
      });
    }

    // R2ストレージへのアップロード
    const storage = locals.runtime.env.STORAGE as R2Bucket;
    if (!storage) {
      return new Response(JSON.stringify({ error: 'R2 storage not configured' }), {
        status: 500,
        headers: { 'Content-Type': 'application/json' },
      });
    }

    // ファイル名を生成（UUID + 元の拡張子）
    const fileExt = file.name.split('.').pop() || 'file';
    const uuid = crypto.randomUUID();
    const fileName = `${uuid}.${fileExt}`;
    
    // タイプに応じたパス設定
    let fileKey = `${type}/${fileName}`;
    
    if (type === 'before-after' || type === 'treatment') {
      // 既存の画像アップロードは before-afters/ プレフィックスを維持
      fileKey = `before-afters/${type}/${fileName}`;
    } else if (type === 'counseling') {
      fileKey = `counseling/${fileName}`;
    } else if (type === 'protocol') {
      fileKey = `protocols/${fileName}`;
    } else if (type === 'training') {
      fileKey = `training/${fileName}`;
    }

    // R2にアップロード
    await storage.put(fileKey, file.stream(), {
      httpMetadata: {
        contentType: file.type,
        cacheControl: 'public, max-age=31536000', // 1年間キャッシュ
      },
      customMetadata: {
        originalName: file.name,
        uploadedAt: new Date().toISOString(),
      },
    });

    // 公開URLを生成
    // R2バケットがパブリックアクセス可能な場合、以下のURL形式を使用
    // 注意: 実際の環境に合わせてURLを調整してください
    // const publicUrl = `https://pub-${locals.runtime.env.STORAGE.accountId}.r2.dev/${fileKey}`;
    
    // カスタムドメインを使用する場合（推奨）:
    // const publicUrl = `https://assets.ledianclinic.jp/${fileKey}`;
    
    // 一時的には、R2バケットのパブリックURLを使用
    // 実際のデプロイ時には、カスタムドメインを設定してください
    const publicUrl = fileKey; // フロントエンドで適切なURLに変換

    return new Response(JSON.stringify({
      success: true,
      url: publicUrl,
      key: fileKey,
      fileName: file.name,
      size: file.size,
      type: file.type,
    }), {
      status: 200,
      headers: { 'Content-Type': 'application/json' },
    });
  } catch (error) {
    console.error('Upload error:', error);
    return new Response(JSON.stringify({
      error: 'Internal Server Error',
      message: error instanceof Error ? error.message : 'Unknown error',
    }), {
      status: 500,
      headers: { 'Content-Type': 'application/json' },
    });
  }
};

