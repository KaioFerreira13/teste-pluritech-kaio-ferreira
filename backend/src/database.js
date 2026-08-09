import path from "node:path";
import { fileURLToPath } from "node:url";
import { JSONFilePreset } from "lowdb/node";

const currentDirectory = path.dirname(fileURLToPath(import.meta.url));
const databasePath = path.resolve(currentDirectory, "../data/db.json");

export const db = await JSONFilePreset(databasePath, { 
    stays: [], 
    counters: {
        dog: 0,
        cat: 0,
    }
});

