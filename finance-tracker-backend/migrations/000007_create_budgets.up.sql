CREATE TABLE IF NOT EXISTS budgets (
    id          BIGSERIAL PRIMARY KEY,
    created_at  TIMESTAMPTZ   NOT NULL DEFAULT NOW(),
    updated_at  TIMESTAMPTZ   NOT NULL DEFAULT NOW(),
    deleted_at  TIMESTAMPTZ,
    user_id     BIGINT        NOT NULL REFERENCES users(id)      ON DELETE CASCADE,
    category_id BIGINT        NOT NULL REFERENCES categories(id) ON DELETE CASCADE,
    amount      NUMERIC(15,2) NOT NULL,
    currency    VARCHAR(10)   NOT NULL DEFAULT 'KZT',
    period      VARCHAR(20)   NOT NULL CHECK (period IN ('daily', 'weekly', 'monthly', 'yearly')),
    start_date  TIMESTAMPTZ   NOT NULL,
    end_date    TIMESTAMPTZ   NOT NULL
);

CREATE INDEX IF NOT EXISTS idx_budgets_deleted_at  ON budgets(deleted_at);
CREATE INDEX IF NOT EXISTS idx_budgets_user_id     ON budgets(user_id);
CREATE INDEX IF NOT EXISTS idx_budgets_category_id ON budgets(category_id);
