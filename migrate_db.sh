#!/bin/bash

echo "Running DB migration..."

psql -U app -d mywebapp <<EOF

CREATE TABLE IF NOT EXISTS items (
    id SERIAL PRIMARY KEY,
    name TEXT NOT NULL,
    quantity INT NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

EOF

echo "Migration done!"
