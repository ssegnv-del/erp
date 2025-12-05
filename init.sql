
PRAGMA foreign_keys = ON;

-- users & roles
CREATE TABLE IF NOT EXISTS users (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  nome TEXT NOT NULL,
  email TEXT UNIQUE,
  senha_hash TEXT NOT NULL,
  role TEXT NOT NULL,
  telefone TEXT,
  ativo INTEGER DEFAULT 1,
  criado_em TEXT DEFAULT (datetime('now'))
);

-- clients
CREATE TABLE IF NOT EXISTS clients (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  nome TEXT NOT NULL,
  cpf_cnpj TEXT,
  telefone TEXT,
  email TEXT,
  endereco_json TEXT,
  obs TEXT,
  criado_em TEXT DEFAULT (datetime('now'))
);

-- products & inventory
CREATE TABLE IF NOT EXISTS products (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  sku TEXT UNIQUE,
  descricao TEXT NOT NULL,
  marca TEXT,
  custo REAL DEFAULT 0,
  preco_venda REAL DEFAULT 0,
  estoque INTEGER DEFAULT 0,
  estoque_minimo INTEGER DEFAULT 0,
  localizacao TEXT,
  created_at TEXT DEFAULT CURRENT_TIMESTAMP,
  updated_at TEXT DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE IF NOT EXISTS inventory_movements (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  product_id INTEGER NOT NULL,
  quantidade INTEGER NOT NULL,
  tipo TEXT NOT NULL, -- entrada/saida/ajuste
  origem TEXT,
  destino TEXT,
  data TEXT DEFAULT CURRENT_TIMESTAMP,
  user_id INTEGER,
  FOREIGN KEY(product_id) REFERENCES products(id)
);

-- orders (sales / pedidos)
CREATE TABLE IF NOT EXISTS orders (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  cliente_id INTEGER,
  criado_por INTEGER,
  data_pedido TEXT DEFAULT (datetime('now')),
  total REAL DEFAULT 0,
  status TEXT DEFAULT 'orcamento',
  tipo TEXT DEFAULT 'venda',
  itens_json TEXT,
  pago INTEGER DEFAULT 0,
  FOREIGN KEY(cliente_id) REFERENCES clients(id),
  FOREIGN KEY(criado_por) REFERENCES users(id)
);

CREATE TABLE IF NOT EXISTS order_items (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  order_id INTEGER,
  product_id INTEGER,
  qtd REAL DEFAULT 1,
  preco_unitario REAL DEFAULT 0,
  desconto REAL DEFAULT 0,
  FOREIGN KEY(order_id) REFERENCES orders(id),
  FOREIGN KEY(product_id) REFERENCES products(id)
);

-- technicians & service orders
CREATE TABLE IF NOT EXISTS technicians (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  nome TEXT NOT NULL,
  fone TEXT,
  veiculo TEXT,
  disponibilidade TEXT DEFAULT 'disponivel',
  criado_em TEXT DEFAULT (datetime('now'))
);

CREATE TABLE IF NOT EXISTS service_orders (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  cliente_id INTEGER,
  endereco TEXT,
  tecnico_id INTEGER,
  data_agendada TEXT,
  data_inicio TEXT,
  data_fim TEXT,
  status TEXT DEFAULT 'aberto',
  descricao TEXT,
  materiais_json TEXT,
  custo_mao_obra REAL DEFAULT 0,
  fotos_json TEXT,
  assinatura_cliente BLOB,
  criado_por INTEGER,
  criado_em TEXT DEFAULT (datetime('now')),
  FOREIGN KEY(cliente_id) REFERENCES clients(id),
  FOREIGN KEY(tecnico_id) REFERENCES technicians(id),
  FOREIGN KEY(criado_por) REFERENCES users(id)
);

-- OS specific items (os_itens)
CREATE TABLE IF NOT EXISTS os (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  cliente_id INTEGER NOT NULL,
  descricao TEXT NOT NULL,
  status TEXT DEFAULT 'aberta',
  prioridade TEXT DEFAULT 'normal',
  tecnico TEXT,
  data_abertura TEXT DEFAULT CURRENT_TIMESTAMP,
  data_agendada TEXT,
  data_finalizada TEXT,
  valor REAL DEFAULT 0,
  observacoes TEXT,
  FOREIGN KEY(cliente_id) REFERENCES clients(id)
);

CREATE TABLE IF NOT EXISTS os_itens (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  os_id INTEGER NOT NULL,
  product_id INTEGER,
  quantidade INTEGER DEFAULT 1,
  valor_unit REAL DEFAULT 0,
  subtotal REAL DEFAULT 0,
  FOREIGN KEY(os_id) REFERENCES os(id),
  FOREIGN KEY(product_id) REFERENCES products(id)
);

-- schedules / agenda
CREATE TABLE IF NOT EXISTS schedules (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  client_id INTEGER,
  technician_id INTEGER,
  os_id INTEGER,
  title TEXT NOT NULL,
  description TEXT,
  date TEXT NOT NULL,
  start_time TEXT NOT NULL,
  end_time TEXT NOT NULL,
  status TEXT DEFAULT 'agendado',
  created_at TEXT DEFAULT CURRENT_TIMESTAMP,
  updated_at TEXT DEFAULT CURRENT_TIMESTAMP
);

-- finance
CREATE TABLE IF NOT EXISTS finance_categories (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  name TEXT NOT NULL,
  type TEXT NOT NULL CHECK(type IN ('receita','despesa')),
  created_at TEXT DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE IF NOT EXISTS finance_transactions (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  category_id INTEGER,
  description TEXT NOT NULL,
  amount REAL NOT NULL,
  type TEXT NOT NULL CHECK(type IN ('receber','pagar')),
  due_date TEXT NOT NULL,
  paid_date TEXT,
  status TEXT DEFAULT 'pendente',
  created_at TEXT DEFAULT CURRENT_TIMESTAMP,
  updated_at TEXT DEFAULT CURRENT_TIMESTAMP,
  FOREIGN KEY(category_id) REFERENCES finance_categories(id)
);

-- quotes / proposals
CREATE TABLE IF NOT EXISTS quotes (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  client_id INTEGER NOT NULL,
  title TEXT NOT NULL,
  description TEXT,
  total REAL DEFAULT 0,
  status TEXT DEFAULT 'rascunho',
  created_at TEXT DEFAULT CURRENT_TIMESTAMP,
  updated_at TEXT DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE IF NOT EXISTS quote_items (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  quote_id INTEGER NOT NULL,
  product_id INTEGER,
  qty REAL NOT NULL,
  price REAL NOT NULL,
  subtotal REAL NOT NULL,
  FOREIGN KEY(quote_id) REFERENCES quotes(id),
  FOREIGN KEY(product_id) REFERENCES products(id)
);

-- contracts & billing
CREATE TABLE IF NOT EXISTS contracts (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  client_id INTEGER,
  endereco TEXT,
  valor_mensal REAL,
  inicio DATE,
  modalidade TEXT,
  status TEXT DEFAULT 'ativo',
  created_at TEXT DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE IF NOT EXISTS invoices (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  contrato_id INTEGER,
  cliente_id INTEGER,
  competencia TEXT,
  valor REAL,
  status TEXT DEFAULT 'pendente',
  data_emissao TEXT DEFAULT CURRENT_TIMESTAMP,
  FOREIGN KEY(contrato_id) REFERENCES contracts(id)
);

-- sync & auditing
CREATE TABLE IF NOT EXISTS sync_log (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  entidade TEXT,
  local_id INTEGER,
  remote_id TEXT,
  operacao TEXT,
  payload_json TEXT,
  status TEXT DEFAULT 'pendente',
  tentativa INTEGER DEFAULT 0,
  timestamp TEXT DEFAULT (datetime('now'))
);

CREATE INDEX IF NOT EXISTS idx_clients_nome ON clients(nome);
CREATE INDEX IF NOT EXISTS idx_products_sku ON products(sku);
CREATE INDEX IF NOT EXISTS idx_orders_cliente ON orders(cliente_id);
CREATE INDEX IF NOT EXISTS idx_service_orders_tecnico ON service_orders(tecnico_id);
