SELECT
     CASE
        WHEN DS_LEITO IS NULL THEN 0
        ELSE 1
    END AS internacao,
    p.DT_ATENDIMENTO,
    MP10.indice_interpolado AS MP10,
    -- NO.indice_interpolado AS NO,
    -- NO2.indice_interpolado AS NO2,
    O3.indice_interpolado AS O3,
    TEMP.indice_interpolado AS TEMP,
    UR.indice_interpolado AS UR,
    p.DS_CID,
    -- MP10.data AS data_poluente,
    -- p.DS_LEITO,
    -- p.DT_ALTA,
    CASE
    	WHEN DT_ATENDIMENTO  BETWEEN '2022-03-20' AND '2022-06-20' THEN 1
    ELSE 0
  	END AS outono,
  	CASE
    	WHEN DT_ATENDIMENTO  BETWEEN '2022-06-21' AND '2022-09-22' THEN 1
    ELSE 0
  	END AS inverno,
  	CASE
    	WHEN DT_ATENDIMENTO  BETWEEN '2022-09-23' AND '2022-12-20' THEN 1
    ELSE 0
  	END AS primavera,
  	CASE
    	WHEN DT_ATENDIMENTO  BETWEEN '2022-12-21' AND '2022-12-31' THEN 1
    	WHEN DT_ATENDIMENTO  BETWEEN '2022-01-01' AND '2022-03-19' THEN 1
    ELSE 0
  	END AS verao,
    CASE
        WHEN DATEDIFF(p.DT_ATENDIMENTO, p.DT_NASC) < 365 THEN 1
        ELSE 0
    END AS MENOR_1_ANO,
    CASE
        WHEN DATEDIFF(p.DT_ATENDIMENTO, p.DT_NASC) BETWEEN 365 AND (365*4 + 364) THEN 1
        ELSE 0
    END AS ENTRE_1_4_ANOS,
    CASE
        WHEN DATEDIFF(p.DT_ATENDIMENTO, p.DT_NASC) BETWEEN (365*5) AND (365*9 + 364) THEN 1
        ELSE 0
    END AS ENTRE_5_9_ANOS,
    CASE
        WHEN DATEDIFF(p.DT_ATENDIMENTO, p.DT_NASC) BETWEEN (365*10) AND (365*14 + 364) THEN 1
        ELSE 0
    END AS ENTRE_10_14_ANOS,
    CASE
        WHEN DATEDIFF(p.DT_ATENDIMENTO, p.DT_NASC) BETWEEN (365*15) AND (365*18 + 364) THEN 1
        ELSE 0
    END AS ENTRE_15_18_ANOS,
    -- p.DT_NASC,
    p.TP_SEXO,
    sinais_vitais.*
FROM paciente_interpolacao MP10
JOIN paciente_interpolacao NO ON MP10.id_coordenada = NO.id_coordenada
JOIN paciente_interpolacao NO2 ON MP10.id_coordenada = NO2.id_coordenada
JOIN paciente_interpolacao O3 ON MP10.id_coordenada = O3.id_coordenada
JOIN paciente_interpolacao TEMP ON MP10.id_coordenada = TEMP.id_coordenada
JOIN paciente_interpolacao UR ON MP10.id_coordenada = UR.id_coordenada
JOIN paciente_coordenadas PC ON MP10.id_coordenada = PC.id
JOIN paciente p on PC.id_paciente = p.ID
JOIN (SELECT DISTINCT p.CD_ATENDIMENTO
               , psv_dor.DS_SINAL_VITAL as "ds_dor"
               , psv_dor.valor as "valor_dor"
               , psv_fc.DS_SINAL_VITAL as "ds_fc"
               , psv_fc.valor as "valor_fc"
               , psv_fr.DS_SINAL_VITAL as "ds_fr"
               , psv_fr.valor as "valor_fr"
               , psv_pp.DS_SINAL_VITAL as "ds_pp"
               , psv_pp.valor as "valor_pp"
               , psv_sa.DS_SINAL_VITAL as "ds_sa"
               , psv_sa.valor as "valor_sa"
               , psv_peso.DS_SINAL_VITAL as "ds_peso"
               , psv_peso.valor as "valor_peso"
               , psv_temp.DS_SINAL_VITAL as "ds_temp"
               , psv_temp.valor as "valor_temp"
 FROM paciente p,
      paciente_sinais_vitais psv_dor,
      paciente_sinais_vitais psv_fc,
      paciente_sinais_vitais psv_fr,
      paciente_sinais_vitais psv_pp,
      paciente_sinais_vitais psv_sa,
      paciente_sinais_vitais psv_peso,
      paciente_sinais_vitais psv_temp
 WHERE p.CD_ATENDIMENTO = psv_dor.CD_ATENDIMENTO
   AND psv_dor.DS_SINAL_VITAL = 'DOR'
   AND p.CD_ATENDIMENTO = psv_fc.CD_ATENDIMENTO
   AND psv_fc.DS_SINAL_VITAL = 'FREQUÊNCIA CARDÍACA'
   AND p.CD_ATENDIMENTO = psv_fr.CD_ATENDIMENTO
   AND psv_fr.DS_SINAL_VITAL = 'FREQUÊNCIA RESPIRATÓRIA'
   AND p.CD_ATENDIMENTO = psv_pp.CD_ATENDIMENTO
   AND psv_pp.DS_SINAL_VITAL = 'PERFUSAO PERIFERICA'
   AND p.CD_ATENDIMENTO = psv_peso.CD_ATENDIMENTO
   AND psv_peso.DS_SINAL_VITAL = 'PESO'
   AND p.CD_ATENDIMENTO = psv_sa.CD_ATENDIMENTO
   AND psv_sa.DS_SINAL_VITAL = 'SATURAÇÃO (AR AMBIENTE)'
   AND p.CD_ATENDIMENTO = psv_temp.CD_ATENDIMENTO
   AND psv_temp.DS_SINAL_VITAL = 'TEMPERATURA') sinais_vitais
WHERE
    MP10.poluente = 'MP10'
    AND NO.poluente = 'NO'
    AND NO2.poluente = 'NO2'
    AND O3.poluente = 'O3'
    AND TEMP.poluente = 'TEMP'
    AND UR.poluente = 'UR'
    AND sinais_vitais.CD_ATENDIMENTO = p.CD_ATENDIMENTO
    AND STR_TO_DATE(MP10.data, '%Y%m%d') BETWEEN STR_TO_DATE('20220101', '%Y%m%d')  AND STR_TO_DATE('20221231', '%Y%m%d')
order by MP10.id asc;