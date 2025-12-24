/**
 * D1 Database utility functions
 */

export interface D1Database {
  prepare(query: string): D1PreparedStatement;
  exec(query: string): Promise<D1Result>;
  batch<T = unknown>(statements: D1PreparedStatement[]): Promise<D1Result<T>[]>;
}

export interface D1PreparedStatement {
  bind(...values: unknown[]): D1PreparedStatement;
  first<T = unknown>(colName?: string): Promise<T | null>;
  run(): Promise<D1Result>;
  all<T = unknown>(): Promise<D1Result<T>>;
  raw<T = unknown>(): Promise<T[]>;
}

export interface D1Result<T = unknown> {
  success: boolean;
  meta: {
    duration: number;
    changes: number;
    last_row_id: number;
    rows_read: number;
    rows_written: number;
  };
  results?: T[];
  error?: string;
}

/**
 * Get D1 database instance from runtime
 */
export function getDB(env: { DB?: D1Database }): D1Database {
  if (!env.DB) {
    throw new Error('D1 database is not available. Make sure DB binding is configured.');
  }
  return env.DB;
}

/**
 * Helper function to execute a query and return results
 */
export async function queryDB<T = unknown>(
  db: D1Database,
  query: string,
  params: unknown[] = []
): Promise<T[]> {
  const stmt = db.prepare(query);
  if (params.length > 0) {
    stmt.bind(...params);
  }
  const result = await stmt.all<T>();
  if (!result.success) {
    throw new Error(result.error || 'Database query failed');
  }
  return result.results || [];
}

/**
 * Helper function to execute a query and return first row
 */
export async function queryFirst<T = unknown>(
  db: D1Database,
  query: string,
  params: unknown[] = []
): Promise<T | null> {
  const stmt = db.prepare(query);
  if (params.length > 0) {
    stmt.bind(...params);
  }
  return await stmt.first<T>();
}

/**
 * Helper function to execute an INSERT/UPDATE/DELETE query
 */
export async function executeDB(
  db: D1Database,
  query: string,
  params: unknown[] = []
): Promise<D1Result> {
  const stmt = db.prepare(query);
  if (params.length > 0) {
    stmt.bind(...params);
  }
  const result = await stmt.run();
  if (!result.success) {
    throw new Error(result.error || 'Database execution failed');
  }
  return result;
}

