#!/bin/bash
set -e

psql -v ON_ERROR_STOP=1 --username "$POSTGRES_USER" <<-EOSQL
    CREATE USER flashcardbot;
    CREATE DATABASE flashcardbot_test;
    CREATE DATABASE flashcardbot_production;
    CREATE DATABASE flashcardbot_development;
    GRANT ALL PRIVILEGES ON DATABASE flashcardbot_test TO flashcardbot;
    GRANT ALL PRIVILEGES ON DATABASE flashcardbot_production TO flashcardbot;
    GRANT ALL PRIVILEGES ON DATABASE flashcardbot_development TO flashcardbot;
EOSQL
