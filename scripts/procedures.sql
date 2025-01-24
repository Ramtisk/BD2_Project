-- Procedure para gerar um pagamento somando os valores dos planos associados a uma subscrição com desconto
CREATE OR REPLACE PROCEDURE generate_payment(subscription_id INT)
LANGUAGE plpgsql AS $$
DECLARE
    total_amount NUMERIC := 0;
    discount_percent NUMERIC := 0;
BEGIN
    -- Calcular o total dos preços dos planos associados à subscrição
    SELECT SUM(p.price)
    INTO total_amount
    FROM plan p
    JOIN plan_subscription ps ON p.plan_id = ps.plan_id
    WHERE ps.subscription_id = subscription_id;

    -- Verificar se há desconto associado à subscrição
    SELECT d.percent
    INTO discount_percent
    FROM subscription s
    LEFT JOIN discount d ON s.discount_id = d.discount_id
    WHERE s.subscription_id = subscription_id;

    -- Aplicar desconto se existir
    IF discount_percent IS NOT NULL THEN
        total_amount := total_amount * ((100 - discount_percent) / 100);
    END IF;

    -- Inserir o pagamento na tabela
    INSERT INTO payment (subscription_id, user_id, amount, date)
    SELECT subscription_id, user_id, total_amount, NOW()
    FROM subscription
    WHERE subscription_id = subscription_id;
END;
$$;