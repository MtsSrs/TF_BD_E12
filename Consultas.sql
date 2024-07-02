-- -------- < Trabalho Final  > --------
--
--            SCRIPT DE CONSULTA (DML)
--
-- Data Criacao ...........: 02/07/2024
-- Autor(es) ..............: Mateus Frauzino, Daniel Veras e Matheus Arruda 
-- Banco de Dados .........: MySQL 8.0
-- Base de Dados (nome) ...: financial
--
-- PROJETO => 01 Base de Dados
--         => 09 Tabelas
--
-- Ultimas Alteracoes
--   02/07/2024 => Criação das views para listar informações estratégicas
-- ---------------------------------------------------------

USE financial;

-- View para listar clientes com informações de distrito
CREATE VIEW vw_clientes_distritos AS
SELECT 
    c.client_id, -- Identificador do cliente
    c.gender, -- Gênero do cliente
    c.birth_date, -- Data de nascimento do cliente
    d.A2 AS district_name, -- Nome do distrito do cliente
    d.A3 AS region -- Região do distrito
FROM 
    client c
JOIN 
    district d ON c.district_id = d.district_id;

-- View para listar contas com informações de distrito e cliente
CREATE VIEW vw_contas_completas AS
SELECT 
    a.account_id, -- Identificador da conta
    a.frequency, -- Frequência de transações da conta
    a.date AS account_creation_date, -- Data de criação da conta
    d.A2 AS district_name, -- Nome do distrito da conta
    d.A3 AS region, -- Região do distrito
    c.client_id, -- Identificador do cliente
    c.gender, -- Gênero do cliente
    c.birth_date -- Data de nascimento do cliente
FROM 
    account a
JOIN 
    district d ON a.district_id = d.district_id
JOIN 
    disp dp ON a.account_id = dp.account_id
JOIN 
    client c ON dp.client_id = c.client_id;

-- View para listar cartões com informações de cliente e conta
CREATE VIEW vw_cartoes_completos AS
SELECT 
    ca.card_id, -- Identificador do cartão
    ca.type AS card_type, -- Tipo do cartão (crédito/débito)
    ca.issued AS issue_date, -- Data de emissão do cartão
    c.client_id, -- Identificador do cliente
    c.gender, -- Gênero do cliente
    c.birth_date, -- Data de nascimento do cliente
    a.account_id, -- Identificador da conta associada ao cartão
    a.frequency -- Frequência de transações da conta
FROM 
    card ca
JOIN 
    disp dp ON ca.disp_id = dp.disp_id
JOIN 
    client c ON dp.client_id = c.client_id
JOIN 
    account a ON dp.account_id = a.account_id;

-- View para listar empréstimos com informações de conta e cliente
CREATE VIEW vw_emprestimos_completos AS
SELECT 
    l.loan_id, -- Identificador do empréstimo
    l.amount AS loan_amount, -- Quantia do empréstimo
    l.duration AS loan_duration, -- Duração do empréstimo em meses
    l.payments AS monthly_payment, -- Pagamento mensal do empréstimo
    l.status AS loan_status, -- Status do empréstimo (ativo/liquidado)
    c.client_id, -- Identificador do cliente
    c.gender, -- Gênero do cliente
    c.birth_date, -- Data de nascimento do cliente
    a.account_id, -- Identificador da conta associada ao empréstimo
    a.frequency -- Frequência de transações da conta
FROM 
    loan l
JOIN 
    account a ON l.account_id = a.account_id
JOIN 
    disp dp ON a.account_id = dp.account_id
JOIN 
    client c ON dp.client_id = c.client_id;

-- View para listar transações com informações de conta e cliente
CREATE VIEW vw_transacoes_completas AS
SELECT 
    t.trans_id, -- Identificador da transação
    t.date AS transaction_date, -- Data da transação
    t.type AS transaction_type, -- Tipo de transação (débito/crédito)
    t.operation, -- Operação realizada
    t.amount AS transaction_amount, -- Quantia da transação
    t.balance AS account_balance, -- Saldo da conta após a transação
    t.k_symbol, -- Símbolo da transação
    t.bank, -- Banco envolvido na transação
    t.account AS target_account, -- Conta de destino da transação
    c.client_id, -- Identificador do cliente
    c.gender, -- Gênero do cliente
    c.birth_date, -- Data de nascimento do cliente
    a.account_id, -- Identificador da conta
    a.frequency -- Frequência de transações da conta
FROM 
    trans t
JOIN 
    account a ON t.account_id = a.account_id
JOIN 
    disp dp ON a.account_id = dp.account_id
JOIN 
    client c ON dp.client_id = c.client_id;

-- Exemplo de como chamar as views
-- 1. Exibir todos os clientes com informações de distrito
SELECT * FROM vw_clientes_distritos;

-- 2. Exibir todas as contas com informações de distrito e cliente
SELECT * FROM vw_contas_completas;

-- 3. Exibir todos os cartões com informações de cliente e conta
SELECT * FROM vw_cartoes_completos;

-- 4. Exibir todos os empréstimos com informações de conta e cliente
SELECT * FROM vw_emprestimos_completos;

-- 5. Exibir todas as transações com informações de conta e cliente
SELECT * FROM vw_transacoes_completas;
