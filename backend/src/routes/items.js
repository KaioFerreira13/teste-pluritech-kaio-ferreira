import { randomUUID } from "node:crypto";
import { Router } from "express";
import { db } from "../database.js";

export const itemsRouter = Router();

itemsRouter.get("/", (_request, response) => {
  response.json(db.data.items);
});

itemsRouter.post("/", async (request, response) => {
  const name = request.body?.name?.trim();

  if (!name) {
    return response.status(400).json({ message: "O campo name e obrigatorio" });
  }

  const item = { id: randomUUID(), name, createdAt: new Date().toISOString() };
  db.data.items.push(item);
  await db.write();

  return response.status(201).json(item);
});

