CREATE TABLE IF NOT EXISTS categories (
                                          id         BIGSERIAL    PRIMARY KEY,
                                          created_at TIMESTAMPTZ  NOT NULL DEFAULT NOW(),
    updated_at TIMESTAMPTZ  NOT NULL DEFAULT NOW(),
    deleted_at TIMESTAMPTZ,
    user_id    BIGINT       REFERENCES users(id) ON DELETE CASCADE,
    name       VARCHAR(255) NOT NULL,
    type       VARCHAR(20)  NOT NULL CHECK (type IN ('income', 'expense', 'transfer')),
    icon       VARCHAR(100)
    );

CREATE INDEX IF NOT EXISTS idx_categories_deleted_at ON categories(deleted_at);
CREATE INDEX IF NOT EXISTS idx_categories_user_id    ON categories(user_id);