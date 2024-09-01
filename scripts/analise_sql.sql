-- 1. Quantos chamados foram abertos no dia 01/04/2023?
SELECT COUNT(*) AS total_chamados
FROM `datario.adm_central_atendimento_1746.chamado`
WHERE DATE(data_inicio) = '2023-04-01';

-- Resposta: 1756 chamados foram abertos no dia 01/04/2023

-- 2. Qual o tipo de chamado que teve mais chamados abertos no dia 01/04/2023?
SELECT tipo, COUNT(*) AS type_total
FROM `datario.adm_central_atendimento_1746.chamado`
WHERE DATE(data_inicio) = '2023-04-01'
GROUP BY tipo
ORDER BY type_total DESC
LIMIT 1;

-- Resposta: O tipo de chamado que teve mais chamados abertos foi 
-- 'Estacionamento irregular' com 366 chamados

-- 3. Quais os nomes dos 3 bairros que mais tiveram chamados abertos nesse dia?
SELECT b.nome, 
COUNT(*) AS total_chamados_bairro
FROM `datario.adm_central_atendimento_1746.chamado` AS c
INNER JOIN `datario.dados_mestres.bairro` AS b
ON c.id_bairro = b.id_bairro
WHERE DATE(c.data_inicio) = '2023-04-01'
GROUP BY b.nome
ORDER BY total_chamados_bairro DESC
LIMIT 3;

/*
Resposta: 
    1º: Campo Grande - Chamados: 113
    2º: Tijuca - Chamados: 89
    3º: Barra da Tijuca - Chamados: 59
*/

-- 4. Qual o nome da subprefeitura com mais chamados abertos nesse dia?
SELECT 
    b.subprefeitura AS subprefeitura_name,
    COUNT(*) AS total_chamados_subprefeitura
FROM 
    `datario.adm_central_atendimento_1746.chamado` AS c
LEFT JOIN 
    `datario.dados_mestres.bairro` AS b
ON 
    c.id_bairro = b.id_bairro
WHERE 
    DATE(c.data_inicio) = '2023-04-01'
GROUP BY 
    b.subprefeitura
ORDER BY 
    total_chamados_subprefeitura DESC
LIMIT 1;

-- Resposta: A subprefeitura com mais chamados abertos foi Zona Norte com 510 chamados

-- 5. Existe algum chamado aberto nesse dia que não foi associado a um bairro ou 
-- subprefeitura na tabela de bairros? Se sim, por que isso acontece?
SELECT 
    c.id_chamado,
    c.data_inicio,
    c.id_bairro,
    b.id_bairro AS bairro_associado
FROM 
    `datario.adm_central_atendimento_1746.chamado` AS c
LEFT JOIN 
    `datario.dados_mestres.bairro` AS b
ON 
    c.id_bairro = b.id_bairro
WHERE 
    DATE(c.data_inicio) = '2023-04-01'
    AND b.id_bairro IS NULL;

/*
Resposta: Existem 50 chamados abertos que não foi associado a um bairro ou 
subprefeitura na tabela de bairros.
*/

-- 6. Quantos chamados com o subtipo "Perturbação do sossego" foram abertos desde 
-- 01/01/2022 até 31/12/2023 (incluindo extremidades)?
SELECT 
    COUNT(*) AS total_chamados
FROM 
    `datario.adm_central_atendimento_1746.chamado`
WHERE 
    subtipo = 'Perturbação do sossego'
    AND DATE(data_inicio) BETWEEN '2022-01-01' AND '2023-12-31';

-- Resposta: Foram abertos 42830 chamados do subtipo "Perturbação do sossego"

-- 7. Selecione os chamados com esse subtipo que foram abertos durante os eventos 
-- contidos na tabela de eventos (Reveillon, Carnaval e Rock in Rio).
SELECT 
    c.id_chamado,
    c.data_inicio,
    e.evento,
    e.data_inicial AS data_inicio_evento,
    e.data_final AS data_fim_evento
FROM 
    `datario.adm_central_atendimento_1746.chamado` AS c
JOIN 
    `datario.turismo_fluxo_visitantes.rede_hoteleira_ocupacao_eventos` AS e
ON 
    DATE(c.data_inicio) BETWEEN DATE(e.data_inicial) AND DATE(e.data_final)
WHERE 
    c.subtipo = 'Perturbação do sossego'
    AND e.evento IN ('Reveillon', 'Carnaval', 'Rock in Rio');

-- Resposta: 1214 chamados selecionados

-- 8. Quantos chamados desse subtipo foram abertos em cada evento?
SELECT 
    e.evento,
    COUNT(c.id_chamado) AS total_chamados_evento
FROM 
    `datario.adm_central_atendimento_1746.chamado` AS c
JOIN 
    `datario.turismo_fluxo_visitantes.rede_hoteleira_ocupacao_eventos` AS e
ON 
    DATE(c.data_inicio) BETWEEN DATE(e.data_inicial) AND DATE(e.data_final)
WHERE 
    c.subtipo = 'Perturbação do sossego'
    AND e.evento IN ('Reveillon', 'Carnaval', 'Rock in Rio')
GROUP BY 
    e.evento;
/*
Resposta: Total de chamados do subtipo 'Perturbação do sossego' para cada evento:
Rock in Rio: 834; Carnaval: 241; Reveillon: 139.
*/

-- 9. Qual evento teve a maior média diária de chamados abertos desse subtipo?
SELECT 
    e.evento,
    ROUND(COUNT(c.id_chamado) / COUNT(DISTINCT DATE(c.data_inicio)), 2) AS media_diaria_chamados
FROM 
    `datario.adm_central_atendimento_1746.chamado` AS c
JOIN 
    `datario.turismo_fluxo_visitantes.rede_hoteleira_ocupacao_eventos` AS e
ON 
    DATE(c.data_inicio) BETWEEN DATE(e.data_inicial) AND DATE(e.data_final)
WHERE 
    c.subtipo = 'Perturbação do sossego'
    AND e.evento IN ('Reveillon', 'Carnaval', 'Rock in Rio')
GROUP BY 
    e.evento
ORDER BY 
    media_diaria_chamados DESC
LIMIT 1;

-- Resposta: O evento com a maior média diária de chamados abertos foi no Rock in Rio com média de 119.14.

-- 10. Compare as médias diárias de chamados abertos desse subtipo durante os eventos específicos 
-- (Reveillon, Carnaval e Rock in Rio) e a média diária de chamados abertos desse subtipo considerando todo o período de 01/01/2022 até 31/12/2023.
WITH total_chamados AS (
    SELECT 
        COUNT(*) AS total_chamados,
        COUNT(DISTINCT DATE(data_inicio)) AS total_dias
    FROM 
        `datario.adm_central_atendimento_1746.chamado`
    WHERE 
        subtipo = 'Perturbação do sossego'
        AND DATE(data_inicio) BETWEEN '2022-01-01' AND '2023-12-31'
),
eventos_chamados AS (
    SELECT 
        e.evento,
        COUNT(c.id_chamado) AS total_chamados_evento,
        COUNT(DISTINCT DATE(c.data_inicio)) AS total_dias_evento
    FROM 
        `datario.adm_central_atendimento_1746.chamado` AS c
    JOIN 
        `datario.turismo_fluxo_visitantes.rede_hoteleira_ocupacao_eventos` AS e
    ON 
        DATE(c.data_inicio) BETWEEN DATE(e.data_inicial) AND DATE(e.data_final)
    WHERE 
        c.subtipo = 'Perturbação do sossego'
        AND e.evento IN ('Reveillon', 'Carnaval', 'Rock in Rio')
    GROUP BY 
        e.evento
)
SELECT 
    'Total Geral' AS periodo,
    ROUND(total_chamados.total_chamados / total_chamados.total_dias, 2) AS media_diaria
FROM 
    total_chamados
UNION ALL
SELECT 
    evento,
    ROUND(total_chamados_evento / total_dias_evento, 2) AS media_diaria
FROM 
    eventos_chamados;

/*
Resposta: 
Carnaval: 60.25; Rock in Rio: 119.14; Reveillon: 46.33;	Total Geral: 61.98.
*/