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

sudo -u postgres psql -d mywebapp <<EOF

GRANT ALL ON SCHEMA public TO app;
ALTER SCHEMA public OWNER TO app;
ALTER ROLE app SET search_path TO public;

GRANT ALL PRIVILEGES ON ALL TABLES IN SCHEMA public TO app;
GRANT ALL PRIVILEGES ON ALL SEQUENCES IN SCHEMA public TO app;

ALTER DEFAULT PRIVILEGES IN SCHEMA public
GRANT ALL ON TABLES TO app;

ALTER DEFAULT PRIVILEGES IN SCHEMA public
GRANT ALL ON SEQUENCES TO app;

EOF

echo "Database ready!"