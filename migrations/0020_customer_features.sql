-- Customer currency preferences, free-service campaigns, support tickets and manual payment requests.
ALTER TABLE users ADD COLUMN currency_code TEXT NOT NULL DEFAULT 'USDT';
CREATE TABLE IF NOT EXISTS free_services (
 id INTEGER PRIMARY KEY AUTOINCREMENT, service_id INTEGER NOT NULL UNIQUE, enabled INTEGER NOT NULL DEFAULT 1,
 min_qty INTEGER NOT NULL DEFAULT 1, max_qty INTEGER NOT NULL DEFAULT 1000,
 reset_seconds INTEGER NOT NULL DEFAULT 86400, title TEXT NOT NULL DEFAULT '', created_at INTEGER NOT NULL
);
CREATE TABLE IF NOT EXISTS free_service_channels (
 id INTEGER PRIMARY KEY AUTOINCREMENT, campaign_id INTEGER NOT NULL REFERENCES free_services(id) ON DELETE CASCADE,
 chat_id TEXT NOT NULL, channel_url TEXT NOT NULL, title TEXT NOT NULL DEFAULT '', UNIQUE(campaign_id,chat_id)
);
CREATE TABLE IF NOT EXISTS free_service_claims (
 id INTEGER PRIMARY KEY AUTOINCREMENT, user_id INTEGER NOT NULL, campaign_id INTEGER NOT NULL,
 service_id INTEGER NOT NULL, quantity INTEGER NOT NULL, created_at INTEGER NOT NULL
);
CREATE INDEX IF NOT EXISTS free_claim_user ON free_service_claims(user_id,campaign_id,created_at DESC);
CREATE TABLE IF NOT EXISTS support_tickets (
 id INTEGER PRIMARY KEY AUTOINCREMENT, user_id INTEGER NOT NULL, subject TEXT NOT NULL,
 status TEXT NOT NULL DEFAULT 'open', created_at INTEGER NOT NULL, updated_at INTEGER NOT NULL
);
CREATE TABLE IF NOT EXISTS support_messages (
 id INTEGER PRIMARY KEY AUTOINCREMENT, ticket_id INTEGER NOT NULL, sender_id INTEGER NOT NULL,
 is_admin INTEGER NOT NULL DEFAULT 0, body TEXT NOT NULL, created_at INTEGER NOT NULL
);
CREATE INDEX IF NOT EXISTS ticket_user ON support_tickets(user_id,updated_at DESC);
CREATE TABLE IF NOT EXISTS manual_payment_requests (
 id INTEGER PRIMARY KEY AUTOINCREMENT, user_id INTEGER NOT NULL, method_id INTEGER NOT NULL,
 amount_usd INTEGER NOT NULL, amount_display REAL NOT NULL, currency_code TEXT NOT NULL,
 proof_file_id TEXT, status TEXT NOT NULL DEFAULT 'pending', created_at INTEGER NOT NULL,
 reviewed_at INTEGER, reviewed_by INTEGER
);
CREATE INDEX IF NOT EXISTS manual_payments_status ON manual_payment_requests(status,created_at DESC);
