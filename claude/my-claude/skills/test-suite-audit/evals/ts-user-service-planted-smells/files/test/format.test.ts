import { initials, planLabel } from "../src/format";

describe("initials", () => {
  it("takes first letter of each word, uppercased", () => {
    expect(initials("ann marie lee")).toBe("AML");
  });
  it("ignores repeated whitespace", () => {
    expect(initials("  Bo   Chen ")).toBe("BC");
  });
  it("returns empty string for empty name", () => {
    expect(initials("")).toBe("");
  });
});

describe("planLabel", () => {
  it("maps known plans", () => {
    expect(planLabel("pro")).toBe("Pro");
    expect(planLabel("team")).toBe("Team");
  });
  it("falls back to Free", () => {
    expect(planLabel("enterprise-trial")).toBe("Free");
  });
});
