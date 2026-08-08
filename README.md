# Teste Pluritech

Aplicação web com backend Node.js, frontend Flutter e persistência local em JSON.

## Pré-requisitos

- Node.js 20 ou superior
- Flutter 3.44 ou superior, com suporte web habilitado
- Chrome ou Edge

## Executar em desenvolvimento

Abra dois terminais na raiz do projeto.

Backend:

```powershell
cd backend
npm run dev
```

Frontend (porta compatível com o CORS padrão do backend):

```powershell
cd frontend
flutter run -d chrome --web-port 8080
```

A API ficará em `http://localhost:3000/api` e o frontend em
`http://localhost:8080`.

Para usar outra URL de API:

```powershell
flutter run -d chrome --web-port 8080 --dart-define=API_URL=http://localhost:3000/api
```

## Testes e build

```powershell
cd backend
npm test

cd ../frontend
flutter analyze
flutter test
flutter build web
```

Os registros do backend ficam em `backend/data/db.json`. O arquivo
`backend/.env.example` contém as configurações opcionais da API.

## Endpoints iniciais

- `GET /api/health`: verifica se a API está ativa
- `GET /api/items`: lista os itens
- `POST /api/items`: cria um item usando JSON no formato `{ "name": "Exemplo" }`
