USE PROJETO1;

-- Consulta 1: Procura docentes e suas respectivas teses de doutorado cuja tese foi defendida na UNICAMP e o sexo do docente é masculino

SELECT  NOME_COMPLETO,
        TITULO_DA_DISSERTACAO_TESE
FROM    DOCENTE D
        INNER JOIN DOUTORADO T
        ON    D.DOCENTE_ID = T.DOCENTE_ID
WHERE   T.NOME_INSTITUICAO = "Universidade Estadual de Campinas" AND D.SEXO = "H";

-- Consulta 2: Procura docentes, suas respectivas linhas de pesquisa e o numero de prêmios/titulos que tenham adquirido mais de 10 premios/titulos, ordenados pelo total de premios/titulos.

SELECT  NOME_COMPLETO,
        TITULO AS LINHA_DE_PESQUISA,
        T.NUM_PREMIOS AS NUM_PREMIOS
FROM    DOCENTE D
        INNER JOIN LINHA_DE_PESQUISA L
        ON    D.DOCENTE_ID = L.DOCENTE_ID
        INNER JOIN (
                    SELECT COUNT(PREMIO_TITULO_ID) AS NUM_PREMIOS,
									E.DOCENTE_ID
                    FROM   DOCENTE E
                           INNER JOIN PREMIO_TITULO P
                           ON    E.DOCENTE_ID = P.DOCENTE_ID
					GROUP BY P.DOCENTE_ID
                    ) T
        ON     D.DOCENTE_ID = T.DOCENTE_ID
WHERE   T.NUM_PREMIOS > 10
ORDER BY T.NUM_PREMIOS;

-- Consulta 3: Procura docentes que fizeram Graduação, Mestrado e Doutorado na mesma instituição

SELECT  NOME_COMPLETO,
        T.NOME_INSTITUICAO
FROM    DOCENTE D
        INNER JOIN DOUTORADO T
        ON    D.DOCENTE_ID = T.DOCENTE_ID
        INNER JOIN MESTRADO M
        ON    D.DOCENTE_ID = M.DOCENTE_ID
        INNER JOIN GRADUACAO G
        ON    D.DOCENTE_ID = G.DOCENTE_ID
WHERE   T.NOME_INSTITUICAO = M.NOME_INSTITUICAO AND T.NOME_INSTITUICAO = G.NOME_INSTITUICAO
ORDER BY NOME_COMPLETO;

-- Consulta 4: Lista os projetos (e seus integrantes) que ainda estao em andamento, sao coordenados por mulheres e se iniciaram depois de 2012 em ordem crescente de ano de inicio.

SELECT  T.ANO_INICIO,
				D.NOME_COMPLETO AS RESPONSAVEL_PROJETO,
                T.NOME_COMPLETO AS NOME_INTEGRANTE,
				T.NOME AS NOME_PROJETO
FROM    DOCENTE D
        INNER JOIN (
                    SELECT  NOME,
                            NOME_COMPLETO,
                            DOCENTE_ID AS ID,
                            ANO_INICIO
                    FROM    PROJETO_DE_PESQUISA P
                            INNER JOIN INTEGRANTE_DO_PROJETO I
                            ON P.PROJETO_ID = I.PROJETO_ID
					WHERE P.SITUACAO = 'EM_ANDAMENTO'
                    ORDER BY NOME_COMPLETO
                    ) T
        ON          D.DOCENTE_ID = T.ID
WHERE SEXO = "M" AND T.ANO_INICIO > 2012
ORDER BY T.ANO_INICIO;

-- Consulta 5: Procura docentes e o respectivo numero de artigos publicados cujo numero de participações em bancas seja maior que o numero de orientações realizadas

SELECT  NOME_COMPLETO,
        T.NUM_ARTIGOS AS NUM_ARTIGOS,
        Q.NUM_ORIENTACAO AS NUM_ORIENTACOES,
        P.NUM_BANCA AS NUM_BANCAS_PARTICIPADAS
FROM    DOCENTE D
        INNER JOIN (
                    SELECT  COUNT(ARTIGO_ID) AS NUM_ARTIGOS,
                            E.DOCENTE_ID
                    FROM    DOCENTE E
                            INNER JOIN ARTIGO A
                            ON    E.DOCENTE_ID = A.DOCENTE_ID
                    GROUP BY E.DOCENTE_ID
                    ) T
        ON          D.DOCENTE_ID = T.DOCENTE_ID
        INNER JOIN (
                    SELECT  COUNT(BANCA_ID) AS NUM_BANCA,
                            F.DOCENTE_ID
                    FROM    DOCENTE F
                            INNER JOIN BANCA B
                            ON    F.DOCENTE_ID = B.DOCENTE_ID
                    GROUP BY B.DOCENTE_ID
                    ) P
        ON          D.DOCENTE_ID = P.DOCENTE_ID
        INNER JOIN (
                    SELECT  COUNT(ORIENTACAO_ID) AS NUM_ORIENTACAO,
                            G.DOCENTE_ID
                    FROM    DOCENTE G
                            INNER JOIN ORIENTACAO O
                            ON    G.DOCENTE_ID = O.DOCENTE_ID
                    GROUP BY O.DOCENTE_ID
                ) Q
        ON          D.DOCENTE_ID = Q.DOCENTE_ID
WHERE   P.NUM_BANCA > Q.NUM_ORIENTACAO
ORDER BY T.NUM_ARTIGOS;

