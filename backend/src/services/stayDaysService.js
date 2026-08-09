import { dateFromString } from "./dateService.js";

const MILLISECONDS_PER_DAY = 1000 * 60 * 60 * 24;

function daysBetween(startDate, endDate) {
  const difference = endDate.getTime() - startDate.getTime();
  const days = Math.floor(difference / MILLISECONDS_PER_DAY);

  return Math.max(1, days);
}

export function calculateStayDays(
  entryDate,
  expectedExitDate,
  currentDate = new Date(),
) {
  const entry = dateFromString(entryDate);
  const today = new Date(
    Date.UTC(
      currentDate.getFullYear(),
      currentDate.getMonth(),
      currentDate.getDate(),
    ),
  );
  const currentDays = daysBetween(entry, today);
  const expectedTotalDays = expectedExitDate
    ? daysBetween(entry, dateFromString(expectedExitDate))
    : null;

  return {
    currentDays,
    expectedTotalDays,
  };
}
