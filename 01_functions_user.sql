CREATE OR REPLACE FUNCTION entity_get_all(
    include_deleted BOOLEAN DEFAULT FALSE
)
RETURNS TABLE (
    id INTEGER,
    rut VARCHAR,
    type VARCHAR,
    first_name VARCHAR,
    last_name_father VARCHAR,
    last_name_mother VARCHAR,
    business_name VARCHAR,
    address VARCHAR,
    commune_id INTEGER,
    email VARCHAR,
    phone VARCHAR,
    deleted BOOLEAN,
    created_at TIMESTAMP,
    updated_at TIMESTAMP
)
LANGUAGE sql STABLE AS $$
    SELECT
        e.id,
        e.rut,
        e.type,
        e.first_name,
        e.last_name_father,
        e.last_name_mother,
        e.business_name,
        e.address,
        e.commune_id,
        e.email,
        e.phone,
        e.deleted,
        e.created_at,
        e.updated_at
    FROM entity e
    WHERE (include_deleted = TRUE OR e.deleted = FALSE)
    ORDER BY e.created_at DESC;
$$;

CREATE OR REPLACE FUNCTION entity_get_by_rut(
    p_rut VARCHAR
)
RETURNS TABLE (
    id INTEGER,
    rut VARCHAR,
    type VARCHAR,
    first_name VARCHAR,
    last_name_father VARCHAR,
    last_name_mother VARCHAR,
    business_name VARCHAR,
    address VARCHAR,
    commune_id INTEGER,
    email VARCHAR,
    phone VARCHAR,
    deleted BOOLEAN,
    created_at TIMESTAMP,
    updated_at TIMESTAMP
)
LANGUAGE sql STABLE AS $$
    SELECT
        e.id,
        e.rut,
        e.type,
        e.first_name,
        e.last_name_father,
        e.last_name_mother,
        e.business_name,
        e.address,
        e.commune_id,
        e.email,
        e.phone,
        e.deleted,
        e.created_at,
        e.updated_at
    FROM entity e
    WHERE e.rut = p_rut;
$$;

CREATE OR REPLACE FUNCTION entity_upsert(
    p_rut VARCHAR,
    p_type VARCHAR,
    p_first_name VARCHAR,
    p_last_name_father VARCHAR,
    p_last_name_mother VARCHAR,
    p_business_name VARCHAR,
    p_address VARCHAR,
    p_commune_id INT,
    p_email VARCHAR,
    p_phone VARCHAR
)
RETURNS SETOF entity
LANGUAGE sql
AS $$
INSERT INTO entity (
    rut,
    type,
    first_name,
    last_name_father,
    last_name_mother,
    business_name,
    address,
    commune_id,
    email,
    phone
)
VALUES (
    p_rut,
    p_type,
    p_first_name,
    p_last_name_father,
    p_last_name_mother,
    p_business_name,
    p_address,
    p_commune_id,
    p_email,
    p_phone
)
ON CONFLICT (rut)
DO UPDATE SET
    type = EXCLUDED.type,
    first_name = EXCLUDED.first_name,
    last_name_father = EXCLUDED.last_name_father,
    last_name_mother = EXCLUDED.last_name_mother,
    business_name = EXCLUDED.business_name,
    address = EXCLUDED.address,
    commune_id = EXCLUDED.commune_id,
    email = EXCLUDED.email,
    phone = EXCLUDED.phone,
    updated_at = NOW()
RETURNING *;
$$;

CREATE OR REPLACE FUNCTION entity_soft_delete(
    p_rut VARCHAR
)
RETURNS BOOLEAN
LANGUAGE plpgsql AS $$
BEGIN
    UPDATE entity
    SET
        deleted = TRUE,
        updated_at = now()
    WHERE rut = p_rut
      AND deleted = FALSE;

    RETURN FOUND;
END;
$$;

CREATE OR REPLACE FUNCTION entity_restore(
    p_rut VARCHAR
)
RETURNS BOOLEAN
LANGUAGE plpgsql AS $$
BEGIN
    UPDATE entity
    SET
        deleted = FALSE,
        updated_at = now()
    WHERE rut = p_rut
      AND deleted = TRUE;

    RETURN FOUND;
END;
$$;

CREATE OR REPLACE FUNCTION provider_add(
    p_entity_id INT
)
RETURNS BOOLEAN
LANGUAGE plpgsql AS $$
BEGIN
    INSERT INTO provider(entity_id)
    VALUES (p_entity_id)
    ON CONFLICT DO NOTHING;

    RETURN TRUE;
END;
$$;

CREATE OR REPLACE FUNCTION client_add(
    p_entity_id INT
)
RETURNS BOOLEAN
LANGUAGE plpgsql AS $$
BEGIN
    INSERT INTO client(entity_id)
    VALUES (p_entity_id)
    ON CONFLICT DO NOTHING;

    RETURN TRUE;
END;
$$;

CREATE OR REPLACE FUNCTION advisor_add(
    p_entity_id INT
)
RETURNS BOOLEAN
LANGUAGE plpgsql AS $$
BEGIN
    INSERT INTO advisor(entity_id)
    VALUES (p_entity_id)
    ON CONFLICT DO NOTHING;

    RETURN TRUE;
END;
$$;