import { db } from "../database.js";

export function generateStayCode(species) {
    db.data.counters[species] += 1;

    const prefix = species.toUpperCase();
    const number = String(db.data.counters[species]);

    return `${prefix}-${number}`;
}