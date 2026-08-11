import assert from "node:assert/strict";
import test from "node:test";
import { validateStay } from "../src/services/dataValidation.js";

const validStay = {
  tutorName: "Maria",
  tutorContact: {
    email: "maria@email.com",
    phone: "11999999999",
  },
  species: "dog",
  breed: "SRD",
  entryDate: "2026-08-08",
  expectedExitDate: "2026-08-12",
};

test("aceita uma hospedagem valida", () => {
  assert.equal(validateStay(validStay), null);
});

test("rejeita contato sem telefone", () => {
  const result = validateStay({
    ...validStay,
    tutorContact: {
      email: "maria@email.com",
      phone: "",
    },
  });

  assert.equal(
    result,
    "Preencha todos os campos obrigatorios!",
  );
});

test("rejeita contato sem email", () => {
  const result = validateStay({
    ...validStay,
    tutorContact: {
      email: "",
      phone: "11999999999",
    },
  });

  assert.equal(
    result,
    "Preencha todos os campos obrigatorios!",
  );
});

test("aceita hospedagem sem previsao de saida", () => {
  const result = validateStay({
    ...validStay,
    expectedExitDate: null,
  });

  assert.equal(result, null);
});

test("rejeita campos obrigatorios vazios", () => {
  const result = validateStay({
    ...validStay,
    tutorName: "",
  });

  assert.equal(result, "Preencha todos os campos obrigatorios!");
});

test("rejeita especie invalida", () => {
  const result = validateStay({
    ...validStay,
    species: "bird",
  });

  assert.equal(result, "Especie invalida!");
});

test("rejeita data de entrada invalida", () => {
  const result = validateStay({
    ...validStay,
    entryDate: "08/08/2026",
  });

  assert.equal(result, "Data de entrada invalida!");
});

test("rejeita data de saida invalida", () => {
  const result = validateStay({
    ...validStay,
    expectedExitDate: "2026-02-31",
  });

  assert.equal(result, "Previsao de saida invalida!");
});

test("rejeita data de saida anterior a data de entrada", () => {
  const result = validateStay({
    ...validStay,
    expectedExitDate: "2026-08-07",
    entryDate: "2026-08-08",
  });

  assert.equal(
    result,
    "A previsão de saida não pode ser anterior a data de entrada!",
  );
});

test("rejeita campo preenchido somente com espacos", () => {
  const result = validateStay({
    ...validStay,
    tutorName: "   ",
  });

  assert.equal(result, "Preencha todos os campos obrigatorios!");
});
