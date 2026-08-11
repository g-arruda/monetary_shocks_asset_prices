# Máscara re-derivada no Teste C: o que decidir antes da submissão

*Escrito em 2026-08-10 (pop-os). Projeto: monetary_shocks_asset_prices. Contexto: o corte dos
testes B/D/4 das duas baterias de confound deixou o Teste C carregando §5.2 sozinho, e
fechar a objeção do council contra ele produziu o único número da rodada que anda contra.*

## O achado

O filtro JK é regra de duas pernas (`sign(e_di_bs) != sign(e_ibov_bs)`). Até 2026-08-10 o
Teste C limpava só a perna de juros e reagregava sobre a mesma lista de 62 dias.

| o que se limpa | ξ_mp cheia | ξ_mp pré-COVID |
|---|---|---|
| nada (produção) | 10,43 | 12,22 |
| valores, EMBI+câmbio | 10,72 | 8,18 |
| valores, +CDS | 12,68 | 9,93 |
| valores **e máscara** | **5,57** | 10,94 |

Causa: o bloco de risco explica 15,4% de `e_di_bs` e **40,4%** de `e_ibov_bs`. A perna de
ações é encharcada de risco soberano e é o sinal dela que seleciona os dias. 62 → 63 dias,
mas só 50 coincidem (rotatividade de ~20%).

Sinais inconvenientes: `price_ipca` inverte no impacto (−0,070 → +0,082, nulo nos dois);
`asset_ibov` vira sig90 negativo (−11,8); `denom_vs_prod` = 0,726 explica fator 1,38 das
magnitudes maiores, mas câmbio sobe 1,65× e CDS 2,20×.

## Por que só apareceu agora

1. O princípio "a força vive na máscara" existe desde a auditoria de fidelidade de 14/07 e
   elegeu `z_jk_bs_purif` como produção, mas nunca foi aplicado ao próprio Teste C, escrito
   em 31/07 como operação sobre valores. O council de 10/08 apontou; virou item aberto.
2. **Apareceu agora porque cortamos o Teste B.** Enquanto B existia, C era uma perna de
   quatro. Sem B, C carrega a subseção e a fragilidade dele deixa de ser item de lista.

## A decisão que resta para a v1

A escolha real não é incluir ou não o número ruim: **sem o teste, a frase de fecho de §5.2
volta a ser a que o council marcou como overstate** ("sobrevive a remover esse conteúdo por
completo"). As opções são incluir o teste ou recuar a afirmação.

**Recomendação: manter.** (i) Referee que conhece JK sabe que é regra de seleção e pergunta
pela máscara. (ii) O resultado é a favor — curva, câmbio e risco soberano seguem sig90,
nenhum sinal significativo inverte, AR limitado. (iii) Defesa que os números sustentam:
pré-COVID a ordem inverte (10,94 contra 12,22) e o denominador cresce, ou seja a
re-derivação só destrói força onde juros e risco soberano se moveram juntos — se a política
causa o prêmio de risco, ortogonalizar a perna de ações remove sinal monetário verdadeiro da
seleção, e remove mais onde o canal é mais forte. Mesma lógica de limite inferior já
enunciada para os valores.

**Se espaço for a restrição amarrada:** cortar as *magnitudes*, não o teste. Reportar sinais
preservados + ξ_mp 5,57 (direção, não intervalo), e omitir o par 0,248 / 63,9. Elimina de uma
vez o problema de inflação e a ressalva de denominador, custando duas frases.

**O que não pode acontecer em versão nenhuma:** usar o `asset_ibov` sig90 negativo para
consertar o bloco nulo de §4.6. Variante mais fraca da tabela, conjunto de dias 20%
diferente, denominador 27% menor.

## Estado atual do texto

§5.2 já está escrita com o teste dentro (7 parágrafos, era 8) e com as duas inconveniências
declaradas: a inversão do IPCA e a ressalva de que o ganho do Ibovespa não pode ir para §4.6.
