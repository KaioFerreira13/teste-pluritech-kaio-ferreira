import assert from "node:assert/strict";
import test from "node:test";
import request from "supertest";
import { app } from "../src/app.js";

test("GET /api/health retorna o status da API", async () => {
  const response = await request(app).get("/api/health");

  assert.equal(response.status, 200);
  assert.deepEqual(response.body, { status: "ok" });
});
