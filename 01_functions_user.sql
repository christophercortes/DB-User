-- ==================
-- PERSON: GET ALL
-- ==================
CREATE OR REPLACE FUNCTION person_get_all(
    include_deleted BOOLEAN DEFAULT FALSE
)
RETURNS TABLE (
    rut VARCHAR,
    first_name VARCHAR,
    last_name_father VARCHAR,
    last_name_mother VARCHAR,
    address VARCHAR,
    commune VARCHAR,
    email VARCHAR,
    phone VARCHAR,
    deleted BOOLEAN,
    created_at TIMESTAMP,
    updated_at TIMESTAMP
)
LANGUAGE sql STABLE AS $$
    SELECT
        p.rut,
        p.first_name,
        p.last_name_father,
        p.last_name_mother,
        p.address,
        p.commune,
        p.email,
        p.phone,
        p.deleted,
        p.created_at,
        p.updated_at
    FROM person p
    WHERE (include_deleted = TRUE OR p.deleted = FALSE)
    ORDER BY p.created_at DESC;
$$;
--- ==================
--- Commune: GET ALL
--- ==================
CREATE OR REPLACE FUNCTION commune_get_all()
RETURNS TABLE (
    id INTEGER,
    name VARCHAR
)
LANGUAGE sql
STABLE
AS $$
    SELECT
        c.id,
        c.name
    FROM commune c
    ORDER BY c.name;
$$;

-- ==================
-- PERSON: GET BY RUT
-- ==================
CREATE OR REPLACE FUNCTION person_get_by_rut(
    p_rut VARCHAR
)
RETURNS TABLE (
    rut VARCHAR,
    first_name VARCHAR,
    last_name_father VARCHAR,
    last_name_mother VARCHAR,
    address VARCHAR,
    commune VARCHAR,
    email VARCHAR,
    phone VARCHAR,
    deleted BOOLEAN,
    created_at TIMESTAMP,
    updated_at TIMESTAMP
)
LANGUAGE sql STABLE AS $$
    SELECT
        p.rut,
        p.first_name,
        p.last_name_father,
        p.last_name_mother,
        p.address,
        p.commune,
        p.email,
        p.phone,
        p.deleted,
        p.created_at,
        p.updated_at
    FROM person p
    WHERE p.rut = p_rut;
$$;

-- ==================
-- PERSON: UPSERT
-- ==================
CREATE FUNCTION person_upsert(
    p_rut VARCHAR,
    p_first_name VARCHAR,
    p_last_name_father VARCHAR,
    p_last_name_mother VARCHAR,
    p_address VARCHAR,
    p_commune VARCHAR,
    p_email VARCHAR,
    p_phone VARCHAR
)
RETURNS SETOF person
LANGUAGE SQL
AS $$
INSERT INTO person (
    rut,
    first_name,
    last_name_father,
    last_name_mother,
    address,
    commune,
    email,
    phone
)
VALUES (
    p_rut,
    p_first_name,
    p_last_name_father,
    p_last_name_mother,
    p_address,
    p_commune,
    p_email,
    p_phone
)
ON CONFLICT (rut)
DO UPDATE SET
    first_name = EXCLUDED.first_name,
    last_name_father = EXCLUDED.last_name_father,
    last_name_mother = EXCLUDED.last_name_mother,
    address = EXCLUDED.address,
    commune = EXCLUDED.commune,
    email = EXCLUDED.email,
    phone = EXCLUDED.phone,
    updated_at = NOW()
RETURNING *;
$$;

-- ==================
-- PERSON: SOFT DELETE
-- ==================
CREATE OR REPLACE FUNCTION person_soft_delete(
    p_rut VARCHAR
)
RETURNS BOOLEAN
LANGUAGE plpgsql AS $$
BEGIN
    UPDATE person
    SET
        deleted = TRUE,
        updated_at = now()
    WHERE rut = p_rut
      AND deleted = FALSE;

    RETURN FOUND;
END;
$$;

-- ==================
-- PERSON: RESTORE
-- ==================
CREATE OR REPLACE FUNCTION person_restore(
    p_rut VARCHAR
)
RETURNS BOOLEAN
LANGUAGE plpgsql AS $$
BEGIN
    UPDATE person
    SET
        deleted = FALSE,
        updated_at = now()
    WHERE rut = p_rut
      AND deleted = TRUE;

    RETURN FOUND;
END;
$$;