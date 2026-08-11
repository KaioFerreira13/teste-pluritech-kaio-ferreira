import { parseDate } from "./dateService.js";

export function validateStay(data) {
  const allowedSpecies = ["dog", "cat"];

  const {
    tutorName,
    tutorContact,
    species,
    breed,
    entryDate,
    expectedExitDate,
  } = data;

  const {
    email,
    phone,
  } = tutorContact ?? {};

  const requiredFields = [tutorName, email, phone, species, breed, entryDate];

  const hasEmptyField = requiredFields.some(
    (value) => typeof value !== "string" || value.trim() === "",
  );

  if (hasEmptyField) {
    return "Preencha todos os campos obrigatorios!";
  }

  if (!allowedSpecies.includes(species)) {
    return "Especie invalida!";
  }

  const parsedEntryDate = parseDate(entryDate);

  if (!parsedEntryDate) {
    return "Data de entrada invalida!";
  }

  const parsedExpectedExitDate = expectedExitDate
    ? parseDate(expectedExitDate)
    : null;

  if (expectedExitDate) {
    if (!parsedExpectedExitDate) {
      return "Previsao de saida invalida!";
    }

    if (parsedExpectedExitDate < parsedEntryDate) {
      return "A previsão de saida não pode ser anterior a data de entrada!";
    }
  }

  return null;
}
