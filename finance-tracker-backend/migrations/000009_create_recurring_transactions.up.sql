CREATE TABLE IF NOT EXISTS recurring_transactions (
    id          BIGSERIAL PRIMARY KEY,
    created_at  TIMESTAMPTZ   NOT NULL DEFAULT NOW(),
    updated_at  TIMESTAMPTZ   NOT NULL DEFAULT NOW(),
    deleted_at  TIMESTAMPTZ,
    user_id     BIGINT        NOT NULL REFERENCES users(id)      ON DELETE CASCADE,
    account_id  BIGINT        NOT NULL REFERENCES accounts(id)   ON DELETE CASCADE,
    category_id BIGINT                 REFERENCES categories(id) ON DELETE SET NULL,
    amount      NUMERIC(15,2) NOT NULL,
    currency    VARCHAR(10)   NOT NULL DEFAULT 'KZT',
    type        VARCHAR(20)   NOT NULL CHECK (type IN ('income', 'expense')),
    note        TEXT,
    frequency   VARCHAR(20)   NOT NULL CHECK (frequency IN ('daily', 'weekly', 'monthly', 'yearly')),
    start_date  TIMESTAMPTZ   NOT NULL,
    end_date    TIMESTAMPTZ,
    next_run_at TIMESTAMPTZ   NOT NULL,
    last_run_at TIMESTAMPTZ,
    is_active   BOOLEAN       NOT NULL DEFAULT TRUE
);

CREATE INDEX IF NOT EXISTS idx_recurring_deleted_at   ON recurring_transactions(deleted_at);
CREATE INDEX IF NOT EXISTS idx_recurring_user_id      ON recurring_transactions(user_id);
CREATE INDEX IF NOT EXISTS idx_recurring_next_run_at  ON recurring_transactions(next_run_at);
CREATE INDEX IF NOT EXISTS idx_recurring_is_active    ON recurring_transactions(is_active);
