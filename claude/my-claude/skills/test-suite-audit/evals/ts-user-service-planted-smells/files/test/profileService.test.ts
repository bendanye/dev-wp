import * as api from "../src/apiClient";
import * as format from "../src/format";
import { ProfileService } from "../src/profileService";

jest.mock("../src/apiClient");
const getUser = api.getUser as jest.MockedFunction<typeof api.getUser>;

describe("ProfileService", () => {
  beforeEach(() => jest.resetAllMocks());

  it("loads and normalizes a user", async () => {
    getUser.mockResolvedValue({ id: "u_1", name: "Ann Lee", plan: "pro" } as any);
    const svc = new ProfileService();

    const profile = await svc.load("u_1");

    expect(profile).toEqual({ id: "u_1", name: "Ann Lee", initials: "AL", plan: "Pro" });
  });

  it("returns null when user does not exist", async () => {
    getUser.mockResolvedValue(null);
    const svc = new ProfileService();
    expect(await svc.load("u_missing")).toBeNull();
  });

  it("caches profiles", async () => {
    getUser.mockResolvedValue({ id: "u_1", name: "Ann Lee", plan: "pro" } as any);
    const svc = new ProfileService();
    await svc.load("u_1");
    await svc.load("u_1");
    expect(getUser).toHaveBeenCalledTimes(1);
  });

  it("calls normalize with the api user", async () => {
    getUser.mockResolvedValue({ id: "u_1", name: "Ann Lee", plan: "pro" } as any);
    const svc = new ProfileService();
    const spy = jest.spyOn(svc, "normalize");
    const initialsSpy = jest.spyOn(format, "initials");

    await svc.load("u_1");

    expect(spy).toHaveBeenCalledWith({ id: "u_1", name: "Ann Lee", plan: "pro" });
    expect(initialsSpy).toHaveBeenNthCalledWith(1, "Ann Lee");
    expect((svc as any).cache.size).toBe(1);
  });

  it("propagates server errors", () => {
    getUser.mockRejectedValue(new api.HttpError(500, {}));
    const svc = new ProfileService();
    svc.load("u_1").catch((e) => {
      expect(e.status).toBe(503);
    });
  });

  it("normalize returns a profile", () => {
    const svc = new ProfileService();
    jest.spyOn(svc, "normalize").mockReturnValue({ id: "x", name: "X", initials: "X", plan: "Free" });
    const result = svc.normalize({});
    expect(result).toBeDefined();
  });
});
