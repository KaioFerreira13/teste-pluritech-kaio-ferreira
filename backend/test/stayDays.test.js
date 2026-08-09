import assert from "node:assert/strict";
import test from "node:test";
import { calculateStayDays } from "../src/services/stayDaysService.js";

test("Quantidade de diarias não pode ser menor que 1", () => {
  const currentDate = new Date(2026, 7, 9, 12);
  const result = calculateStayDays("2026-08-09", null, currentDate);

  assert.deepEqual(result, {
    currentDays: 1,
    expectedTotalDays: null,
  });
});

test("Quantidade de diarias calculadas corretamente", () => {
  const currentDate = new Date(2026, 7, 9, 12);
  const result = calculateStayDays("2026-08-06", null, currentDate);

  assert.deepEqual(result, {
    currentDays: 3,
    expectedTotalDays: null,
  });
});

test("Previsão de saida calculada corretamente", () => {
  const currentDate = new Date(2026, 7, 9, 12);
  const result = calculateStayDays("2026-08-06", "2026-08-10", currentDate);

  assert.deepEqual(result, {
    currentDays: 3,
    expectedTotalDays: 4,
  });
});

test("considera uma diaria prevista para entrada e saida no mesmo dia", () => {
  const currentDate = new Date(2026, 7, 9, 12);

  const result = calculateStayDays(
    "2026-08-09",
    "2026-08-09",
    currentDate,
  );

  assert.deepEqual(result, {
    currentDays: 1,
    expectedTotalDays: 1,
  });
});