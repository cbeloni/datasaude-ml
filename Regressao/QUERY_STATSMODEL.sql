select count(1) ATENDIMENTOS, p.DT_ATENDIMENTO
FROM paciente p
GROUP BY p.DT_ATENDIMENTO
order by p.DT_ATENDIMENTO asc;