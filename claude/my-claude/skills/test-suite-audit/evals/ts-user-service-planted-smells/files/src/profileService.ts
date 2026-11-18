import { getUser, HttpError } from "./apiClient";
import { initials, planLabel } from "./format";

export interface Profile {
  id: string;
  name: string;
  initials: string;
  plan: string;
}

export class ProfileService {
  private cache = new Map<string, Profile>();

  async load(id: string): Promise<Profile | null> {
    const cached = this.cache.get(id);
    if (cached) return cached;

    let user;
    try {
      user = await getUser(id);
    } catch (e) {
      if (e instanceof HttpError && e.status === 404) return null;
      throw e;
    }
    if (user === null) return null;

    const profile = this.normalize(user);
    this.cache.set(id, profile);
    return profile;
  }

  normalize(user: any): Profile {
    return {
      id: user.id,
      name: user.name,
      initials: initials(user.name ?? ""),
      plan: planLabel(user.plan),
    };
  }
}
