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

export type ValidationFieldError = {
  field: string;
  message: string;
};

export const parseIsPublishedParam = (value: string | null) => {
  if (value === null) return null;
  const normalized = value.trim().toLowerCase();
  if (normalized === '1' || normalized === 'true') return 1;
  if (normalized === '0' || normalized === 'false') return 0;
  return null;
};

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
 * Create a 400 validation error response
 */
export function validationError(
  message: string,
  fields: ValidationFieldError[]
): Response {
  return jsonResponse(400, { error: message, fields });
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
export async function withErrorHandling(
  handler: () => Promise<Response>
): Promise<Response> {
  try {
    const result = await handler();
    if (result instanceof Response) {
      return result;
    }
    return errorResponse('Handler did not return a Response', 500, 'INTERNAL_ERROR');
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

type RuntimeEnvFallback = { body: unknown; status: number };

/**
 * Ensure runtime env is available
 */
export function requireRuntimeEnv(
  runtime: App.Locals['runtime'] | undefined,
  fallback: RuntimeEnvFallback = {
    body: { error: 'Runtime env not available' },
    status: 500,
  }
): Response | null {
  if (!runtime?.env) {
    return jsonResponse(fallback.status, fallback.body);
  }
  return null;
}

/**
 * Ensure a required parameter exists
 */
export function requireParam(
  value: string | undefined,
  name = 'ID'
): Response | null {
  if (!value) {
    return jsonResponse(400, { error: `${name} is required` });
  }
  return null;
}


