CREATE OR REPLACE FUNCTION sp_DevicesType_CREATE(
    p_name TEXT,
    p_description TEXT,
    p_image TEXT
)
RETURNS VOID AS $$
BEGIN
    BEGIN
        -- Tentar inserir um novo tipo de dispositivo
        INSERT INTO devices_type (name, description, image)
        VALUES (p_name, p_description, p_image);
    EXCEPTION
        WHEN unique_violation THEN
            -- Atualizar o tipo de dispositivo existente
            UPDATE devices_type
            SET description = p_description, image = p_image
            WHERE name = p_name;
        WHEN OTHERS THEN
            RAISE EXCEPTION 'Erro ao criar ou atualizar tipo de dispositivo: %', SQLERRM;
    END;
END $$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION sp_DevicesType_READ(
    p_name TEXT
)
RETURNS TABLE(device_type_id INTEGER, name TEXT, description TEXT, image TEXT) AS $$
BEGIN
    RETURN QUERY
    SELECT
        d.device_type_id::INTEGER, -- Garante o tipo correto
        d.name::TEXT,
        d.description::TEXT,
        d.image::TEXT
    FROM devices_type d
    WHERE d.name = p_name;
END $$ LANGUAGE plpgsql;


CREATE OR REPLACE FUNCTION sp_DevicesType_UPDATE(
    p_name TEXT,
    p_new_description TEXT,
    p_new_image TEXT
)
RETURNS VOID AS $$
BEGIN
    BEGIN
        UPDATE devices_type
        SET description = p_new_description, image = p_new_image
        WHERE name = p_name;
    EXCEPTION
        WHEN OTHERS THEN
            RAISE EXCEPTION 'Erro ao atualizar tipo de dispositivo: %', SQLERRM;
    END;
END $$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION sp_DevicesType_DELETE(
    p_name TEXT
)
RETURNS VOID AS $$
BEGIN
    BEGIN
        DELETE FROM devices_type
        WHERE name = p_name;
    EXCEPTION
        WHEN OTHERS THEN
            RAISE EXCEPTION 'Erro ao excluir tipo de dispositivo: %', SQLERRM;
    END;
END $$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION TEST_DevicesType_CRUD()
RETURNS TEXT AS $$
DECLARE
    read_result RECORD;
    contador INTEGER;
    resultado TEXT;
BEGIN
    -- Limpar estado inicial
    DELETE FROM devices_type WHERE name = 'Dispositivo Teste';

    -- CREATE
    BEGIN
        PERFORM sp_DevicesType_CREATE('Dispositivo Teste', 'Descrição de teste', NULL);
        SELECT COUNT(*) INTO contador
        FROM devices_type
        WHERE name = 'Dispositivo Teste';
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
        SELECT * INTO read_result FROM sp_DevicesType_READ('Dispositivo Teste');
        IF read_result.device_type_id IS NOT NULL THEN
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
        PERFORM sp_DevicesType_UPDATE('Dispositivo Teste', 'Descrição Atualizada', 'imagem_atualizada.png');
        SELECT * INTO read_result FROM sp_DevicesType_READ('Dispositivo Teste');
        IF read_result.description = 'Descrição Atualizada' AND read_result.image = 'imagem_atualizada.png' THEN
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
        PERFORM sp_DevicesType_DELETE('Dispositivo Teste');
        SELECT COUNT(*) INTO contador
        FROM devices_type
        WHERE name = 'Dispositivo Teste';
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

SELECT TEST_DevicesType_CRUD();

