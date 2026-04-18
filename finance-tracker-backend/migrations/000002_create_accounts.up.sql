CREATE TABLE IF NOT EXISTS accounts (
                                        id         BIGSERIAL    PRIMARY KEY,
                                        created_at TIMESTAMPTZ  NOT NULL DEFAULT NOW(),
    updated_at TIMESTAMPTZ  NOT NULL DEFAULT NOW(),
    deleted_at TIMESTAMPTZ,
    user_id    BIGINT       NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    name       VARCHAR(255) NOT NULL,
    type       VARCHAR(50)  NOT NULL DEFAULT 'cash',
    balance    NUMERIC(15,2) NOT NULL DEFAULT 0,
    currency   VARCHAR(10)  NOT NULL DEFAULT 'KZT'
    );

CREATE INDEX IF NOT EXISTS idx_accounts_deleted_at ON accounts(deleted_at);
CREATE INDEX IF NOT EXISTS idx_accounts_user_id    ON accounts(user_id);