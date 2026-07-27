# Handoff — 2026-07-27 (identificação não-gaussiana GMR implementada)
SESSLOG:[2026-07-27 12:51]
<!-- written by: pop-os at 2026-07-27T12:51:16 -->
*Project: monetary_shocks_asset_prices*

## Session Topic
GMR (2017) PML-ICA implementado como `identification = "nongaussian"`, validado contra a aplicação publicada do artigo, e empiricamente sem poder neste painel.

## Active Decisions
- **Produção continua proxy-SVAR.** Para SBE/ANPEC, manter só ele — decidido nesta sessão.
- **GMR é teste, não estimador** (recomendação; decisão final do autor pendente). Bandas contêm zero em tudo exceto a variável normalizada.
- **Nunca usar `IdSS::estim.SVAR.ICA`** — caminho ICA quebrado para n >= 4; ver `historico_decisoes.md` §0.1.
- **Ramo nongaussian usa bootstrap i.i.d.**, não Rademacher (A.5 exige assimetria). Proxy/het inalterados.
- **Não reduzir q para o gate passar** — AW dá q̂ = 8; seria specification shopping.

## Key Files
- /mnt/storage/Github/Modelo/monetary_shocks_asset_prices/relatorio/working-notes/2026-07-27_identificacao_nao_gaussiana_gmr.md
- /mnt/storage/Github/Modelo/monetary_shocks_asset_prices/output/nongaussian/results.md
- /mnt/storage/Github/Modelo/monetary_shocks_asset_prices/output/nongaussian/gate.md
- /mnt/storage/Github/Modelo/monetary_shocks_asset_prices/_instrucoes/historico_decisoes.md
- /mnt/storage/Github/Modelo/monetary_shocks_asset_prices/_instrucoes/pendencias.md

## Next Steps
- [ ] Decidir enquadramento do GMR (manchete vs teste) e escrever o §5
- [ ] Submeter SBE/ANPEC com proxy-SVAR apenas
- [ ] Converter `output/irf/irf_section.md` para o `tex/main.tex` (§5 ainda não existe no tex)
- [ ] Avaliar Gafarov-Meier-Olea (2018) como robustez frequentista de identificação por conjunto
- [ ] Push das branches; `main` tem commits não enviados

## Context
A implementação é um sucesso verificado — reproduz o §3.2 do artigo (esquema recursivo rejeitado a 5% com output gap, não rejeitado a 10% com unemployment gap) e bate com `IdSS` a 1e-15 nas três funções corretas do pacote. O resultado econômico é negativo e a causa está medida: a agregação do DFM destrói a não-gaussianidade (88,7% → 71,4% → 50,0% de rejeição de JB ao longo do pipeline), o que também explica a rejeição anterior da het. Braun-Brüggemann e Antolín-Díaz foram lidos e são ambos bayesianos; a rota frequentista equivalente é Gafarov-Meier-Olea, já em `artigos/`.
