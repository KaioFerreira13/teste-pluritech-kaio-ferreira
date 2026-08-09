import cors from "cors";
import express from "express";
import { config } from "./config.js";
import { staysRouter } from "./routes/stays.js";

export const app = express();

app.use(cors({ origin: config.corsOrigin }));
app.use(express.json());

app.get("/api/health", (_request, response) => {
  response.json({ status: "ok" });
});

app.use("/api/stays", staysRouter);

app.use((_request, response) => {
  response.status(404).json({ message: "Rota nao encontrada" });
});

