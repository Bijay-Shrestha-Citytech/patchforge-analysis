-- PATCH_ID: 20240220_001_add_test_table
-- PATCH_TYPE: SCHEMA

CREATE TABLE test_features (
    id SERIAL PRIMARY KEY,
    feature_name TEXT NOT NULL,
    enabled BOOLEAN DEFAULT true,
    created_at TIMESTAMP DEFAULT NOW()
);

CREATE INDEX idx_test_features_name ON test_features(feature_name);
EOF

