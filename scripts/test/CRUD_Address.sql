-- ============================================================
-- CRUD para Address (Corrigido)
-- ============================================================

-- Função para criar ou atualizar um endereço
CREATE OR REPLACE FUNCTION sp_Address_CREATE(
    p_street TEXT,
    p_city TEXT,
    p_postal_code TEXT,
    p_country TEXT,
    p_user_id INTEGER
)
RETURNS VOID AS $$ 
BEGIN
    -- Verifica se o user_id existe na tabela auth_user
    IF NOT EXISTS (SELECT 1 FROM auth_user WHERE id = p_user_id) THEN
        RAISE EXCEPTION 'Erro: user_id % não existe na tabela auth_user.', p_user_id;
    END IF;

    -- Se o usuário já tem um endereço, faz UPDATE
    IF EXISTS (SELECT 1 FROM address WHERE user_id = p_user_id) THEN
        UPDATE address
        SET street = p_street, city = p_city, postal_code = p_postal_code, country = p_country
        WHERE user_id = p_user_id;
    ELSE
        -- Se não existir, faz INSERT
        INSERT INTO address (street, city, postal_code, country, user_id)
        VALUES (p_street, p_city, p_postal_code, p_country, p_user_id);
    END IF;
END $$ LANGUAGE plpgsql;

-- Função para deletar um endereço
CREATE OR REPLACE FUNCTION sp_Address_DELETE(
    p_user_id INTEGER
)
RETURNS VOID AS $$ 
BEGIN
    -- Verifica se o endereço existe antes de excluir
    IF EXISTS (SELECT 1 FROM address WHERE user_id = p_user_id) THEN
        DELETE FROM address WHERE user_id = p_user_id;
    ELSE
        RAISE EXCEPTION 'Erro: Nenhum endereço encontrado para user_id %.', p_user_id;
    END IF;
END $$ LANGUAGE plpgsql;

-- Função para testar o CRUD do Address
CREATE OR REPLACE FUNCTION TEST_Address_CRUD()
RETURNS TEXT AS $$ 
DECLARE
    read_result RECORD;
    contador INTEGER;
    resultado TEXT;
BEGIN
    -- Limpar estado inicial
    DELETE FROM address WHERE user_id = 1;

    -- Criar usuário fictício na tabela auth_user (se não existir)
    IF NOT EXISTS (SELECT 1 FROM auth_user WHERE id = 1) THEN
        INSERT INTO auth_user (id, username, password, email, first_name, last_name, 
            is_superuser, is_staff, is_active, date_joined)
        VALUES (1, 'teste', '123456', 'teste@email.com', 'Nome', 'Sobrenome', 
            FALSE, FALSE, TRUE, NOW());
    END IF;

    -- CREATE
    BEGIN
        PERFORM sp_Address_CREATE('Rua Teste', 'Lisboa', '1000-123', 'Portugal', 1);
        SELECT COUNT(*) INTO contador FROM address WHERE user_id = 1;
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
        SELECT * INTO read_result FROM address WHERE user_id = 1;
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
        PERFORM sp_Address_CREATE('Rua Teste', 'Porto', '2000-456', 'Portugal', 1);
        SELECT * INTO read_result FROM address WHERE user_id = 1;
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
        PERFORM sp_Address_DELETE(1);
        SELECT COUNT(*) INTO contador FROM address WHERE user_id = 1;
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
SELECT TEST_Address_CRUD();
