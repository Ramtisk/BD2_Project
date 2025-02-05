-- CRUD para Devices_Type

CREATE OR REPLACE FUNCTION sp_Devices_Type_CREATE(
    p_name TEXT,
    p_description TEXT,
    p_image TEXT
)
RETURNS VOID AS $$
BEGIN
    BEGIN
        INSERT INTO devices_type (name, description, image)
        VALUES (p_name, p_description, p_image);
    EXCEPTION
        WHEN unique_violation THEN
            UPDATE devices_type
            SET description = p_description, image = p_image
            WHERE name = p_name;
        WHEN OTHERS THEN
            RAISE EXCEPTION 'Erro ao criar ou atualizar tipo de dispositivo: %', SQLERRM;
    END;
END $$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION sp_Devices_Type_DELETE(
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

CREATE OR REPLACE FUNCTION TEST_Devices_Type_CRUD()
RETURNS TEXT AS $$
DECLARE
    read_result RECORD;
    contador INTEGER;
    resultado TEXT;
BEGIN
    -- Limpar estado inicial
    DELETE FROM devices_type WHERE name = 'Tipo Teste';

    -- CREATE
    BEGIN
        PERFORM sp_Devices_Type_CREATE('Tipo Teste', 'Descrição Teste', NULL);
        SELECT COUNT(*) INTO contador
        FROM devices_type
        WHERE name = 'Tipo Teste';
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
        SELECT * INTO read_result FROM devices_type WHERE name = 'Tipo Teste';
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
        PERFORM sp_Devices_Type_CREATE('Tipo Teste', 'Descrição Atualizada', NULL);
        SELECT * INTO read_result FROM devices_type WHERE name = 'Tipo Teste';
        IF read_result.description = 'Descrição Atualizada' THEN
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
        PERFORM sp_Devices_Type_DELETE('Tipo Teste');
        SELECT COUNT(*) INTO contador
        FROM devices_type
        WHERE name = 'Tipo Teste';
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
select TEST_Devices_Type_CRUD();