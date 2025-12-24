globalThis.process ??= {}; globalThis.process.env ??= {};
function getDB(env) {
  if (!env.DB) {
    throw new Error("D1 database is not available. Make sure DB binding is configured.");
  }
  return env.DB;
}
async function queryDB(db, query, params = []) {
  const stmt = db.prepare(query);
  if (params.length > 0) {
    stmt.bind(...params);
  }
  const result = await stmt.all();
  if (!result.success) {
    throw new Error(result.error || "Database query failed");
  }
  return result.results || [];
}
async function queryFirst(db, query, params = []) {
  const stmt = db.prepare(query);
  if (params.length > 0) {
    stmt.bind(...params);
  }
  return await stmt.first();
}
async function executeDB(db, query, params = []) {
  const stmt = db.prepare(query);
  if (params.length > 0) {
    stmt.bind(...params);
  }
  const result = await stmt.run();
  if (!result.success) {
    throw new Error(result.error || "Database execution failed");
  }
  return result;
}

export { queryDB as a, executeDB as e, getDB as g, queryFirst as q };
