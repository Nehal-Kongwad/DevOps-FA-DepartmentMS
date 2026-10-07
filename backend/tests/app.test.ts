import request from "supertest";
import app from "../src/app";

describe("Campus Connect Backend API", () => {
  it("GET / should return the welcome message", async () => {
    const response = await request(app).get("/");

    expect(response.status).toBe(200);
    expect(response.body.message).toBe(
      "Welcome to Campus connect Backend API"
    );
  });
});