#!/bin/bash

echo "Setting up database..."

sudo -u postgres psql <<EOF

SELECT 'CREATE DATABASE mywebapp'
WHERE NOT EXISTS (
    SELECT FROM pg_database WHERE datname = 'mywebapp'
)\gexec

DO \$\$
BEGIN
   IF NOT EXISTS (
      SELECT FROM pg_catalog.pg_roles WHERE rolname = 'app'
   ) THEN
      CREATE ROLE app LOGIN PASSWORD '12345678';
   END IF;
END
\$\$;

GRANT ALL PRIVILEGES ON DATABASE mywebapp TO app;

EOF

echo "Database ready!"
