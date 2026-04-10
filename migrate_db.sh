#!/bin/bash

echo "Running DB migration..."

psql -U app -d mywebapp <<EOF

CREATE TABLE IF NOT EXISTS items (
    id SERIAL PRIMARY KEY,
    name TEXT UNIQUE NOT NULL,
    quantity INT NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

INSERT INTO items (name, quantity)
VALUES
  ('Laptop', 10),
  ('Phone', 25),
  ('Keyboard', 15),
  ('Mouse', 30),
  ('Monitor', 8)
ON CONFLICT DO NOTHING;

EOF

echo "Migration done!"
