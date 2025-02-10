-- ============================================================
-- CRUD para Device
-- ============================================================

-- Função para criar ou atualizar um dispositivo
CREATE OR REPLACE FUNCTION sp_Device_CREATE(
    p_device_type_id INTEGER,
    p_installation_date TIMESTAMP WITH TIME ZONE,
    p_serial_number TEXT
)
RETURNS VOID AS $$ 
BEGIN
    -- Verifica se o dispositivo já existe baseado no serial_number
    IF EXISTS (SELECT 1 FROM device WHERE serial_number = p_serial_number) THEN
        -- Se existir, apenas atualiza a installation_date
        UPDATE device
        SET installation_date = p_installation_date
        WHERE serial_number = p_serial_number;
    ELSE
        -- Se não existir, cria um novo registro
        INSERT INTO device (device_type_id, installation_date, serial_number)
        VALUES (p_device_type_id, p_installation_date, p_serial_number);
    END IF;
END $$ LANGUAGE plpgsql;

-- Função para deletar um dispositivo
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

-- Função para testar o CRUD
CREATE OR REPLACE FUNCTION TEST_Device_CRUD()
RETURNS TEXT AS $$ 
DECLARE
    read_result RECORD;
    contador INTEGER;
    resultado TEXT;
BEGIN
    -- Limpar estado inicial
    DELETE FROM device WHERE serial_number = 'SN12345';

    -- CREATE
    BEGIN
        PERFORM sp_Device_CREATE(1, NOW(), 'SN12345');
        SELECT COUNT(*) INTO contador
        FROM device
        WHERE serial_number = 'SN12345';
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
        SELECT * INTO read_result FROM device WHERE serial_number = 'SN12345';
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
        PERFORM sp_Device_CREATE(1, NOW() + INTERVAL '1 day', 'SN12345');
        SELECT * INTO read_result FROM device WHERE serial_number = 'SN12345';
        IF read_result.installation_date > NOW() THEN
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
        PERFORM sp_Device_DELETE('SN12345');
        SELECT COUNT(*) INTO contador
        FROM device
        WHERE serial_number = 'SN12345';
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

-- Executar teste
SELECT TEST_Device_CRUD();
