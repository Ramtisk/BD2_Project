CREATE OR REPLACE FUNCTION sp_Address_CREATE(
    p_street TEXT,
    p_city TEXT,
    p_postal_code TEXT,
    p_country TEXT,
    p_user_id INTEGER
)
RETURNS VOID AS $$
BEGIN
    BEGIN
        -- Tentar inserir um novo endereço
        INSERT INTO address (street, city, postal_code, country, user_id)
        VALUES (p_street, p_city, p_postal_code, p_country, p_user_id);
    EXCEPTION
        WHEN unique_violation THEN
            -- Atualizar o endereço existente
            UPDATE address
            SET street = p_street, city = p_city, postal_code = p_postal_code, country = p_country
            WHERE user_id = p_user_id;
        WHEN OTHERS THEN
            RAISE EXCEPTION 'Erro ao criar ou atualizar endereço: %', SQLERRM;
    END;
END $$ LANGUAGE plpgsql;


CREATE OR REPLACE FUNCTION sp_Address_DELETE(
    p_street TEXT
)
RETURNS VOID AS $$
BEGIN
    BEGIN
        DELETE FROM address
        WHERE street = p_street;
    EXCEPTION
        WHEN OTHERS THEN
            RAISE EXCEPTION 'Erro ao excluir endereço: %', SQLERRM;
    END;
END $$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION TEST_Address_CRUD()
RETURNS TEXT AS $$
DECLARE
    read_result RECORD;
    contador INTEGER;
    resultado TEXT;
BEGIN
    -- Limpar estado inicial
    DELETE FROM address WHERE street = 'Rua Teste';

    -- CREATE com user_id = 2
    BEGIN
        PERFORM sp_Address_CREATE('Rua Teste', 'Lisboa', '1000-123', 'Portugal', 2);
        SELECT COUNT(*) INTO contador
        FROM address
        WHERE street = 'Rua Teste';
        IF contador > 0 THEN
            resultado := 'CREATE: OK;';
        ELSE
            RETURN 'CREATE: NOK;';
        END IF;
    EXCEPTION
        WHEN OTHERS THEN
            RETURN 'CREATE: NOK; Erro inesperado: ' || SQLERRM;
    END;

    -- READ
    BEGIN
        SELECT * INTO read_result FROM sp_Address_READ('Rua Teste');
        IF read_result.address_id IS NOT NULL THEN
            resultado := resultado || ' READ: OK;';
        ELSE
            RETURN resultado || ' READ: NOK;';
        END IF;
    EXCEPTION
        WHEN OTHERS THEN
            RETURN resultado || ' READ: NOK; Erro inesperado: ' || SQLERRM;
    END;

    -- UPDATE
    BEGIN
        PERFORM sp_Address_UPDATE('Rua Teste', 'Porto');
        SELECT * INTO read_result FROM sp_Address_READ('Rua Teste');
        IF read_result.city = 'Porto' THEN
            resultado := resultado || ' UPDATE: OK;';
        ELSE
            RETURN resultado || ' UPDATE: NOK;';
        END IF;
    EXCEPTION
        WHEN OTHERS THEN
            RETURN resultado || ' UPDATE: NOK; Erro inesperado: ' || SQLERRM;
    END;

    -- DELETE
    BEGIN
        PERFORM sp_Address_DELETE('Rua Teste');
        SELECT COUNT(*) INTO contador
        FROM address
        WHERE street = 'Rua Teste';
        IF contador = 0 THEN
            resultado := resultado || ' DELETE: OK;';
        ELSE
            RETURN resultado || ' DELETE: NOK;';
        END IF;
    EXCEPTION
        WHEN OTHERS THEN
            RETURN resultado || ' DELETE: NOK; Erro inesperado: ' || SQLERRM;
    END;

    RETURN resultado;
END $$ LANGUAGE plpgsql;

SELECT TEST_Address_CRUD();