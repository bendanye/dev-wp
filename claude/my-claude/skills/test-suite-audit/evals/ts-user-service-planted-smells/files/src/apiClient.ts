export class HttpError extends Error {
  constructor(public status: number, public body: unknown) {
    super(`HTTP ${status}`);
  }
}

/** Calls GET /v2/users/:id. Response bodies are documented in contracts/. */
export async function getUser(id: string): Promise<any> {
  const res = await fetch(`https://api.internal/v2/users/${id}`);
  if (!res.ok) {
    throw new HttpError(res.status, await res.json());
  }
  return res.json();
}
