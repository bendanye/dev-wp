export function initials(name: string): string {
  return name
    .split(/\s+/)
    .filter(Boolean)
    .map((p) => p[0]!.toUpperCase())
    .join("");
}

export function planLabel(plan: string): string {
  return plan === "pro" ? "Pro" : plan === "team" ? "Team" : "Free";
}
