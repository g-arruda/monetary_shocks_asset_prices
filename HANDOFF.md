# Handoff, 2026-08-18

## Tópico

Migração da seção 4 para a produção de 111 séries e fechamento de três
pendências editoriais da seção 5.

## Decisões ativas

- A seção 4 usa impacto como horizonte editorial comum e abre com DI 5 anos +77,6 pb, BRL/USD +3,84%, EMBI+ +26,2 pb e CDS +32,5 pb.
- Como `xi_mp=6,27`, as bandas de 68% e 90% descrevem incerteza, sem vereditos binários no texto ou marcadores nas seis figuras.
- A reversão é tratada como dinâmica conjunta sensível a `p`, sem atribuição a um modo quase unitário.
- Agregados monetários foram omitidos, não haverá seção ou parágrafo de Limitações e as cautelas ficam nas passagens substantivas.
- O bloco acionário tem sete retornos mensais sem acumulação. O IMAT é interpretado pela receita denominada em dólar.
- A comparação cross-instrumento do IPCA permanece aberta, e a seção 4 não antecipa sua conclusão.
- `fig_placebos.pdf` e `fig_estado.pdf` permaneceram byte a byte inalteradas.
- A seção 5 tem quatro subseções. O diagnóstico de invertibilidade ganhou seção
  própria, fundamentada em Stock e Watson (2018), e não estabelece
  invertibilidade porque o teste tem baixa potência e verifica condição necessária.
- Os testes soberano e FOMC alteram apenas os valores da surpresa e mantêm fixa
  a seleção da máscara de produção. As máscaras rederivadas ficaram fora do paper.
- O impacto BRL/USD é R$ 0,1579 por dólar, ou 3,84% da média amostral. Sob
  reescala linear, corresponde a 7,68% por 100 pontos-base.

## Arquivos-chave

- `paper/paper_anpec.tex`: seção 4 e seis legendas reescritas.
- `script/fig_section5.R`: marcadores removidos somente das seis figuras da seção 4.
- `paper/fig_{curva,cambio_risco,atividade,credito,precos,acoes}.pdf`: figuras regeneradas.
- `registro/pendencias.md`: migração da seção 4 fechada e índice aberto atualizado.
- `README.md`: composição corrente da seção 5.
- `mapa_literatura_risco_soberano_cambio.md` e
  `relatorio/checklist_problemas_sdfm_weak_iv.md`: materiais auxiliares com
  banner de vintage superada.
- `paper/paper_anpec.pdf`: compilação final de 27 páginas.

## Próximos passos

1. Migrar resumo, introdução, revisão de literatura e conclusão para a produção de 111 séries.
2. Rodar a comparação cross-instrumento do IPCA em `(5,5)`.
3. Preservar as alterações não relacionadas já presentes no worktree ao continuar.

## Verificação

- `Rscript script/fig_section5.R` passou nos autotestes.
- `pdflatex` passou sem erros, citações ou referências indefinidas.
- `git diff --check` passou.
- Resta uma caixa excedente preexistente de 10,05 pt nas linhas 173--174, fora da seção 4.
