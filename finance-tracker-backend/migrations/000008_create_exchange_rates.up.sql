CREATE TABLE IF NOT EXISTS exchange_rates (
    id              BIGSERIAL PRIMARY KEY,
    created_at      TIMESTAMPTZ   NOT NULL DEFAULT NOW(),
    updated_at      TIMESTAMPTZ   NOT NULL DEFAULT NOW(),
    deleted_at      TIMESTAMPTZ,
    base_currency   VARCHAR(10)   NOT NULL,
    target_currency VARCHAR(10)   NOT NULL,
    rate            NUMERIC(18,6) NOT NULL,
    date            DATE          NOT NULL
);

CREATE UNIQUE INDEX IF NOT EXISTS idx_exchange_rates_unique
    ON exchange_rates(base_currency, target_currency, date)
    WHERE deleted_at IS NULL;

CREATE INDEX IF NOT EXISTS idx_exchange_rates_deleted_at ON exchange_rates(deleted_at);
CREATE INDEX IF NOT EXISTS idx_exchange_rates_date       ON exchange_rates(date);
