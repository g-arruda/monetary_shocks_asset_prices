# Reavaliação de (r,q) após a correção mensal

## Pergunta

Qual configuração equilibra melhor seleção dos fatores, força do instrumento,
coerência das respostas e estabilidade nas amostras completa e pré-COVID?

## Comparação sem bootstrap

| (r,q) | critério | ξ_mp full | ξ_mp pré-COVID | leitura |
|---|---|---:|---:|---|
| (5,3) | seleção BLL automática | 3,42 | 5,24 | fraco; IRFs extremas |
| (7,6) | produção congelada | 7,65 | 11,53 | fraco na amostra completa |
| (7,7) | melhor maximin no grid | 10,92 | 11,55 | sinais hard 3/3 e extensão 3/3 |
| (8,8) | maior ξ_mp full | 11,62 | 9,51 | abaixo de 10 e ligeiramente explosivo pré-COVID |

A seleção BLL no painel corrente dá r=5 pelos IC1 e IC2 e q=3 pelo
Amengual-Watson com p=6 ou p=12. A célula (5,3), porém, produz ξ_mp abaixo de
3,84 na amostra completa e impacto do Ibovespa próximo de -24%, de modo que não
é uma especificação estrutural defensável.

## Estado da decisão

A produção permanece em (7,6). Se a seleção for formalmente reaberta,
(7,7) é o candidato preferido sob uma regra maximin predefinida, mas deve ser
tratado primeiro como robustez e passar pelo bootstrap de 800 réplicas. Migrar
apenas porque ele recoloca ξ_mp acima de 10 pareceria seleção ex post.
