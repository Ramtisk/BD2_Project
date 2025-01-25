CREATE OR REPLACE FUNCTION sp_Device_CREATE(
    p_device_type_id INTEGER,
    p_installation_date TIMESTAMP,
    p_serial_number TEXT
)
RETURNS VOID AS $$
BEGIN
    BEGIN
        -- Tentar inserir um novo dispositivo
        INSERT INTO device (device_type_id, installation_date, serial_number)
        VALUES (p_device_type_id, p_installation_date, p_serial_number);
    EXCEPTION
        WHEN unique_violation THEN
            -- Atualizar o dispositivo existente
            UPDATE device
            SET installation_date = p_installation_date, device_type_id = p_device_type_id
            WHERE serial_number = p_serial_number;
        WHEN OTHERS THEN
            RAISE EXCEPTION 'Erro ao criar ou atualizar dispositivo: %', SQLERRM;
    END;
END $$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION sp_Device_READ(
    p_serial_number TEXT
)
RETURNS TABLE(device_id INTEGER, device_type_id INTEGER, installation_date TIMESTAMP, serial_number TEXT) AS $$
BEGIN
    RETURN QUERY
    SELECT
        d.device_id::INTEGER,            -- Casting explícito para garantir o tipo correto
        d.device_type_id::INTEGER,
        d.installation_date::TIMESTAMP,
        d.serial_number::TEXT
    FROM device d
    WHERE d.serial_number = p_serial_number; -- Filtro pelo número de série
END $$ LANGUAGE plpgsql;


CREATE OR REPLACE FUNCTION sp_Device_UPDATE(
    p_serial_number TEXT,
    p_new_installation_date TIMESTAMP,
    p_new_device_type_id INTEGER
)
RETURNS VOID AS $$
BEGIN
    BEGIN
        UPDATE device
        SET installation_date = p_new_installation_date, device_type_id = p_new_device_type_id
        WHERE serial_number = p_serial_number;
    EXCEPTION
        WHEN OTHERS THEN
            RAISE EXCEPTION 'Erro ao atualizar dispositivo: %', SQLERRM;
    END;
END $$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION sp_Device_DELETE(
    p_serial_number TEXT
)
RETURNS VOID AS $$
BEGIN
    BEGIN
        DELETE FROM device
        WHERE serial_number = p_serial_number;
    EXCEPTION
        WHEN OTHERS THEN
            RAISE EXCEPTION 'Erro ao excluir dispositivo: %', SQLERRM;
    END;
END $$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION TEST_Device_CRUD()
RETURNS TEXT AS $$
DECLARE
    read_result RECORD;
    contador INTEGER;
    resultado TEXT;
BEGIN
    -- Limpar estado inicial
    DELETE FROM device WHERE serial_number = 'TEST123';

    -- CREATE
    BEGIN
        PERFORM sp_Device_CREATE(1, '2023-01-01 10:00:00', 'TEST123');
        SELECT COUNT(*) INTO contador
        FROM device
        WHERE serial_number = 'TEST123';
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
        SELECT * INTO read_result FROM sp_Device_READ('TEST123');
        IF read_result.device_id IS NOT NULL THEN
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
        PERFORM sp_Device_UPDATE('TEST123', '2024-01-01 10:00:00', 2);
        SELECT * INTO read_result FROM sp_Device_READ('TEST123');
        IF read_result.installation_date = '2024-01-01 10:00:00' THEN
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
        PERFORM sp_Device_DELETE('TEST123');
        SELECT COUNT(*) INTO contador
        FROM device
        WHERE serial_number = 'TEST123';
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

SELECT TEST_Device_CRUD();
