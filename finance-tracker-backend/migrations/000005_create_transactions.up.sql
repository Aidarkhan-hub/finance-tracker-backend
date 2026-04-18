CREATE TABLE IF NOT EXISTS transactions (
    id            BIGSERIAL PRIMARY KEY,
    created_at    TIMESTAMPTZ   NOT NULL DEFAULT NOW(),
    updated_at    TIMESTAMPTZ   NOT NULL DEFAULT NOW(),
    deleted_at    TIMESTAMPTZ,
    user_id       BIGINT        NOT NULL REFERENCES users(id)      ON DELETE CASCADE,
    account_id    BIGINT        NOT NULL REFERENCES accounts(id)   ON DELETE CASCADE,
    category_id   BIGINT                 REFERENCES categories(id) ON DELETE SET NULL,
    to_account_id BIGINT                 REFERENCES accounts(id)   ON DELETE SET NULL,
    amount        NUMERIC(15,2) NOT NULL,
    currency      VARCHAR(10)   NOT NULL DEFAULT 'KZT',
    amount_base   NUMERIC(15,2) NOT NULL DEFAULT 0,
    type          VARCHAR(20)   NOT NULL CHECK (type IN ('income', 'expense', 'transfer')),
    note          TEXT,
    date          TIMESTAMPTZ   NOT NULL DEFAULT NOW()
);

CREATE INDEX IF NOT EXISTS idx_transactions_deleted_at  ON transactions(deleted_at);
CREATE INDEX IF NOT EXISTS idx_transactions_user_id     ON transactions(user_id);
CREATE INDEX IF NOT EXISTS idx_transactions_account_id  ON transactions(account_id);
CREATE INDEX IF NOT EXISTS idx_transactions_category_id ON transactions(category_id);
CREATE INDEX IF NOT EXISTS idx_transactions_date        ON transactions(date);
CREATE INDEX IF NOT EXISTS idx_transactions_type        ON transactions(type);
