-- Create currencies table
CREATE TABLE IF NOT EXISTS currencies (
    currency_id SERIAL PRIMARY KEY,
    currency_code VARCHAR(3) UNIQUE NOT NULL,
    currency_name VARCHAR(50) NOT NULL,
    currency_symbol VARCHAR(10) NOT NULL,
    exchange_rate DECIMAL(10, 6) NOT NULL DEFAULT 1.0,
    is_active BOOLEAN DEFAULT TRUE,
    is_base_currency BOOLEAN DEFAULT FALSE,
    last_updated TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

-- Add currency columns to transactions
ALTER TABLE transactions 
    ADD COLUMN currency_id INTEGER REFERENCES currencies(currency_id),
    ADD COLUMN exchange_rate DECIMAL(10, 6) DEFAULT 1.0,
    ADD COLUMN base_currency_amount DECIMAL(10, 2);

-- Insert default currencies
INSERT INTO currencies (currency_code, currency_name, currency_symbol, exchange_rate, is_base_currency) VALUES
    ('USD', 'US Dollar', '$', 1.000000, TRUE),
    ('EUR', 'Euro', '€', 0.920000, FALSE),
    ('GBP', 'British Pound', '£', 0.790000, FALSE),
    ('JPY', 'Japanese Yen', '¥', 149.500000, FALSE),
    ('NPR', 'Nepalese Rupee', 'Rs', 132.500000, FALSE);

-- Create function to update exchange rates
CREATE OR REPLACE FUNCTION update_currency_exchange_rate(
    p_currency_code VARCHAR(3),
    p_new_rate DECIMAL(10, 6)
)
RETURNS VOID AS $$
BEGIN
    UPDATE currencies
    SET exchange_rate = p_new_rate,
        last_updated = CURRENT_TIMESTAMP
    WHERE currency_code = p_currency_code;
END;
$$ LANGUAGE plpgsql;

-- Create trigger to calculate base currency amount
CREATE OR REPLACE FUNCTION calculate_base_currency_amount()
RETURNS TRIGGER AS $$
BEGIN
    IF NEW.exchange_rate IS NOT NULL AND NEW.net_amount IS NOT NULL THEN
        NEW.base_currency_amount := NEW.net_amount * NEW.exchange_rate;
    END IF;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trg_calculate_base_amount
    BEFORE INSERT OR UPDATE ON transactions
    FOR EACH ROW
    EXECUTE FUNCTION calculate_base_currency_amount();

-- Create indexes
CREATE INDEX idx_currencies_code ON currencies(currency_code);
CREATE INDEX idx_currencies_active ON currencies(is_active);
CREATE INDEX idx_transactions_currency_id ON transactions(currency_id);

COMMENT ON TABLE currencies IS 'Multi-currency support for international transactions';