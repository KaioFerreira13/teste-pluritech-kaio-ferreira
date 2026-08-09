import { randomUUID } from "node:crypto";
import { Router } from "express";
import { db } from "../database.js";
import { generateStayCode } from "../services/code.js";
import { validateStay } from "../services/dataValidation.js";

export const staysRouter = Router();

//rotas GET
staysRouter.get("/", (_request, response) => {
  response.json(db.data.stays);
});

staysRouter.get("/:id", (request, response) => {
  const { id } = request.params;

  const stay = db.data.stays.find((stay) => stay.id === id);

  if (!stay) {
    return response.status(404).json({
      message: "Hospedagem não encontrada!",
    });
  }
  return response.json(stay);
});
// rotas POST
staysRouter.post("/", async (request, response) => {

  const {
    tutorName,
    tutorContact,
    species,
    breed,
    entryDate,
    expectedExitDate,
  } = request.body;
  const validationError = validateStay(request.body);

  if (validationError) {
    return response.status(400).json({
      message: validationError,
    });
  }

  const code = generateStayCode(species);

  const stay = {
    id: randomUUID(),
    code,
    tutorName,
    tutorContact,
    species,
    breed,
    entryDate,
    expectedExitDate: expectedExitDate || null,
    createdAt: new Date().toISOString(),
    updatedAt: new Date().toISOString(),
  };

  db.data.stays.push(stay);
  await db.write();

  return response.status(201).json(stay);

});

// rotas PUT
staysRouter.put("/:id", async (request, response) => {
  const { id } = request.params;
  const stayIndex = db.data.stays.findIndex((stay) => stay.id === id);

  if (stayIndex === -1) {
    return response.status(404).json({
      message: "Hospedagem não encontrada!",
    });
  }

  const validationError = validateStay(request.body);

  if (validationError) {
    return response.status(400).json({
      message: validationError,
    });
  }

  const {
    tutorName,
    tutorContact,
    species,
    breed,
    entryDate,
    expectedExitDate,
  } = request.body;

  const currentStay = db.data.stays[stayIndex];

  const updatedStay = {
    ...currentStay,
    tutorName,
    tutorContact,
    species,
    breed,
    entryDate,
    expectedExitDate: expectedExitDate || null,
    updatedAt: new Date().toISOString(),
  };

  db.data.stays[stayIndex] = updatedStay;
  await db.write();

  return response.json(updatedStay);
});

// rotas DELETE
staysRouter.delete("/:id", async (request, response) => {
  const { id } = request.params;
  const stayIndex = db.data.stays.findIndex((stay) => stay.id === id);

  if (stayIndex === -1) {
    return response.status(404).json({
      message: "Hospedagem não encontrada!",
    });
  }

  const [deletedStay] = db.data.stays.splice(stayIndex, 1);

  await db.write();

  return response.json({
    message: "Hospedagem excluida com sucesso!",
    stay: deletedStay,
  });
});