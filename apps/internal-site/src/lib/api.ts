/**
 * Common API utilities for consistent response handling
 */

export interface ApiError {
  error: string;
  message?: string;
  code?: string;
}

export interface ApiSuccess<T> {
  data: T;
  meta?: {
    total?: number;
    page?: number;
    limit?: number;
  };
}

/**
 * Create a JSON response with proper headers
 */
export function jsonResponse<T>(status: number, body: T): Response {
  return new Response(JSON.stringify(body), {
    status,
    headers: {
      'Content-Type': 'application/json',
      'Cache-Control': 'no-cache',
    },
  });
}

/**
 * Create a success response
 */
export function successResponse<T>(data: T, status = 200): Response {
  return jsonResponse(status, data);
}

/**
 * Create an error response
 */
export function errorResponse(
  message: string,
  status = 500,
  code?: string
): Response {
  const body: ApiError = { error: message };
  if (code) body.code = code;
  return jsonResponse(status, body);
}

/**
 * Create a 404 not found response
 */
export function notFoundResponse(resource = 'Resource'): Response {
  return errorResponse(`${resource} not found`, 404, 'NOT_FOUND');
}

/**
 * Create a 400 bad request response
 */
export function badRequestResponse(message: string): Response {
  return errorResponse(message, 400, 'BAD_REQUEST');
}

/**
 * Create a 500 internal server error response
 */
export function serverErrorResponse(error: unknown): Response {
  const message = error instanceof Error ? error.message : 'Unknown error';
  console.error('Server error:', error);
  return errorResponse(message, 500, 'INTERNAL_ERROR');
}

/**
 * Wrapper for async API handlers with consistent error handling
 */
export async function withErrorHandling<T>(
  handler: () => Promise<T>
): Promise<T | Response> {
  try {
    return await handler();
  } catch (error) {
    return serverErrorResponse(error);
  }
}

/**
 * Check if database is available
 */
export function checkDatabase(locals: App.Locals): Response | null {
  if (!locals?.runtime?.env?.DB) {
    return errorResponse('Database not available', 503, 'DB_UNAVAILABLE');
  }
  return null;
}

