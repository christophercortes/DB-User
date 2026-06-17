CREATE TABLE commune (
    id SERIAL PRIMARY KEY,
    name VARCHAR(100) NOT NULL UNIQUE
);

CREATE TABLE entity (
    id SERIAL PRIMARY KEY,
    rut VARCHAR UNIQUE NOT NULL,
    type VARCHAR(20) CHECK (type IN ('person', 'company')), 
    first_name VARCHAR,
    last_name_father VARCHAR,
    last_name_mother VARCHAR,
    business_name VARCHAR,
    address VARCHAR,
    commune_id INT REFERENCES commune(id),
    email VARCHAR,
    phone VARCHAR,
    deleted BOOLEAN DEFAULT FALSE,
    created_at TIMESTAMP DEFAULT now(),
    updated_at TIMESTAMP DEFAULT now()
);

CREATE TABLE provider (
    id SERIAL PRIMARY KEY,
    entity_id INT NOT NULL REFERENCES entity(id) ON DELETE CASCADE,
    created_at TIMESTAMP DEFAULT now()
);

CREATE TABLE client (
    id SERIAL PRIMARY KEY,
    entity_id INT NOT NULL REFERENCES entity(id) ON DELETE CASCADE,
    created_at TIMESTAMP DEFAULT now()
);

CREATE TABLE advisor (
    id SERIAL PRIMARY KEY,
    entity_id INT NOT NULL REFERENCES entity(id) ON DELETE CASCADE,
    created_at TIMESTAMP DEFAULT now()
);