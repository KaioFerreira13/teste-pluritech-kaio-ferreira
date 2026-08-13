# Hotel para Pets — Teste Pluritech

Aplicação web para gerenciar hospedagens de cães e gatos. O sistema permite
listar, cadastrar, editar e excluir hospedagens, além de calcular a quantidade
atual e prevista de diárias.

## Tecnologias

- Frontend: Flutter Web e Material 3
- Backend: Node.js 20, Express 5 e LowDB
- Persistência: arquivo JSON local
- Testes: Flutter Test e Node.js Test Runner

## Funcionalidades

- Cadastro e edição de hospedagens
- Exclusão com confirmação
- Contato do tutor com validação de e-mail e máscara de telefone
- Seleção das datas de entrada e saída prevista
- Identificação automática da hospedagem por espécie
- Cálculo das diárias atuais e previstas
- Persistência local dos registros

## Estrutura do projeto

```text
.
├── backend/
│   ├── data/             # Banco de dados JSON
│   ├── src/
│   │   ├── routes/       # Endpoints de hospedagens
│   │   └── services/     # Validação, datas, códigos e diárias
│   └── test/             # Testes da API e das regras de negócio
└── frontend/
    ├── lib/
    │   ├── formatters/   # Máscaras de entrada
    │   ├── models/       # Modelos da aplicação
    │   ├── pages/        # Listagem e formulário
    │   └── services/     # Comunicação com a API
    └── test/             # Testes de widgets, modelos e serviços
```

## Pré-requisitos

- Node.js 20 ou superior
- Flutter compatível com Dart 3.12 ou superior
- Suporte web do Flutter habilitado
- Chrome ou Edge

Confira as instalações:

```powershell
node --version
npm --version
flutter --version
```

Se o Flutter estiver sendo gerenciado pelo Puro, substitua `flutter` por
`puro -e stable flutter` nos comandos deste documento.

## Instalação

Na raiz do projeto, instale as dependências do backend:

```powershell
cd backend
npm install
```

Em seguida, instale as dependências do frontend:

```powershell
cd ../frontend
flutter pub get
```

## Configuração

O backend aceita as seguintes variáveis de ambiente:

| Variável | Valor padrão | Descrição |
| --- | --- | --- |
| `PORT` | `3000` | Porta da API |
| `CORS_ORIGIN` | `http://localhost:8080` | Origem permitida pelo CORS |

Para personalizá-las, copie `backend/.env.example` para `backend/.env` e altere
os valores. O frontend usa `http://localhost:3000/api` como endereço padrão da
API. Outra URL pode ser definida em tempo de compilação com `API_URL`.

## Execução em desenvolvimento

Abra dois terminais. No primeiro, execute a API:

```powershell
cd backend
npm run dev
```

No segundo, execute o frontend na porta autorizada pelo CORS:

```powershell
cd frontend
flutter run -d chrome --web-port 8080
```

Endereços locais:

- Frontend: `http://localhost:8080`
- API: `http://localhost:3000/api`
- Verificação da API: `http://localhost:3000/api/health`

Para apontar o frontend para outra API:

```powershell
flutter run -d chrome --web-port 8080 --dart-define=API_URL=http://localhost:3000/api
```

## API

Base URL: `http://localhost:3000/api`

| Método | Endpoint | Descrição | Sucesso |
| --- | --- | --- | --- |
| `GET` | `/health` | Verifica se a API está disponível | `200` |
| `GET` | `/stays` | Lista todas as hospedagens | `200` |
| `GET` | `/stays/:id` | Busca uma hospedagem | `200` |
| `POST` | `/stays` | Cadastra uma hospedagem | `201` |
| `PUT` | `/stays/:id` | Atualiza uma hospedagem | `200` |
| `DELETE` | `/stays/:id` | Exclui uma hospedagem | `200` |

Exemplo de corpo para `POST /stays` e `PUT /stays/:id`:

```json
{
  "tutorName": "Maria Silva",
  "tutorContact": {
    "email": "maria@example.com",
    "phone": "11999999999"
  },
  "species": "dog",
  "breed": "Golden Retriever",
  "entryDate": "2026-08-12",
  "expectedExitDate": "2026-08-18"
}
```

`expectedExitDate` é opcional e pode ser enviado como `null`. As datas usam o
formato `AAAA-MM-DD`. Os valores aceitos para `species` são `dog` e `cat`.

Além dos dados persistidos, as respostas de hospedagem incluem:

- `currentDays`: quantidade de diárias desde a entrada;
- `expectedTotalDays`: quantidade prevista de diárias ou `null` quando não há
  previsão de saída.

Erros de validação retornam status `400`; recursos inexistentes retornam `404`.

## Regras de negócio

- Nome e contato do tutor, espécie, raça e data de entrada são obrigatórios.
- A espécie precisa ser `dog` ou `cat`.
- A saída prevista não pode ser anterior à entrada.
- Uma hospedagem contabiliza no mínimo uma diária.
- O telefone é exibido no frontend como `(##) #####-####`, mas enviado e salvo
  somente com os 11 dígitos.
- O código da hospedagem é gerado automaticamente conforme a espécie.

## Testes e qualidade

Backend:

```powershell
cd backend
npm test
```

Frontend:

```powershell
cd frontend
dart format --output=none --set-exit-if-changed lib test
flutter analyze
flutter test
```

Para gerar a versão web de produção:

```powershell
cd frontend
flutter build web
```

Os arquivos gerados ficam em `frontend/build/web`.

## Persistência

Os registros são armazenados em `backend/data/db.json`. Essa solução é adequada
para desenvolvimento e demonstração local, mas não oferece os recursos de
concorrência, migração e disponibilidade esperados de um banco de produção.
