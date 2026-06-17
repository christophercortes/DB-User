CREATE TABLE person (
    rut VARCHAR PRIMARY KEY,
    first_name VARCHAR,
    last_name_father VARCHAR,
    last_name_mother VARCHAR,
    address VARCHAR,
    commune VARCHAR,
    email VARCHAR,
    phone VARCHAR,
    deleted BOOLEAN DEFAULT FALSE,
    created_at TIMESTAMP DEFAULT now(),
    updated_at TIMESTAMP DEFAULT now()
);

CREATE TABLE commune (
    id SERIAL PRIMARY KEY,
    name VARCHAR(100) NOT NULL UNIQUE
);