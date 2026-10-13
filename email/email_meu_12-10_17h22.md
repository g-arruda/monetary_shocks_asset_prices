Boa tarde, professor.

Rodei os passos 0 a 4:

0) Reconstruí as seis séries Focus anuais pela aproximação de horizonte fixo. No impacto, o câmbio vai de R$ 0,141 para 0,145 por dólar e o CDS de 34,0 para 33,5 p.b., e nenhum ponto das duas séries sai do conjunto de 90% da base anterior até h36. A reversão de longo prazo deixa de ser significante a 90% e continua significante a 80%. O ξ_mp vai de 7,02 para 6,66 na amostra completa e de 6,84 para 5,60 na pré-COVID.

1) Câmbio e CDS são significantes a 95% no impacto (p 0,015 e 0,017), o câmbio até h3 e o CDS em h0, h1, h3 e h4. Na janela pré-COVID, os conjuntos não podem ser calculados com p = 4, porque o teste tem mais momentos (135) que observações (90). Com p = 2, câmbio e CDS são significantes a 95% em h0, h1, h3 e h6. Os termos do teste não mostram autocorrelação até h12, e Newey-West com 1 a 3 defasagens não altera a significância no impacto.

2) No dia do Copom, uma surpresa de +50 p.b. vem acompanhada de apreciação do real de R$ 0,048 (1,04%), significante a 95% tanto com a surpresa bruta quanto com a ortogonalizada. O CDS não é significante a 90%. O primeiro estágio é a identidade com a surpresa bruta e tem F de 656 com a ortogonalizada. O sinal do câmbio só se inverte na passagem do evento diário para o DFM mensal, e não na ortogonalização. Essa passagem muda ao mesmo tempo a frequência, a janela, a normalização, a medida e o modelo, e a rodada não separa esses efeitos. No DFM com a surpresa bruta, câmbio e CDS não são significantes a 90%.

3) Retirando uma reunião por vez, as respostas mudam pouco: o câmbio no impacto fica entre 0,124 e 0,175 e o ξ_mp entre 5,38 e 7,49. Sem as 5 reuniões mais influentes, o ξ_mp cai para 3,54, e câmbio e CDS são significantes a 90% de h0 a h4, mas não a 95%. Sem as 10, o ξ_mp cai para 1,82 e todos os conjuntos de câmbio e CDS são a reta toda. Excluindo as 11 reuniões com movimento extremo de VIX, S&P 500 ou Brent, com a regra fixada antes de rodar, o ξ_mp vai a 5,67 e o CDS fica estável (32,0 p.b., significante a 95%). O câmbio cai 26% no impacto (0,107) e segue significante a 90% de h0 a h4, mas não a 95% em nenhum horizonte. A queda vem sobretudo das reuniões marcadas pelo Brent. Em nenhuma dessas exclusões câmbio ou CDS trocam de sinal nos primeiros horizontes.

4) Para VIX, índice MSCI de emergentes e EPU dos EUA, tomei os p-valores do teste AR de resposta zero em h0, h1, h3, h6, h12 e h24 e apliquei a correção de Holm aos 18 testes:

```
              h0     h1     h3     h6     h12    h24
VIX    p      0,692  0,876  0,126  0,098  0,334  0,370
       Holm   1      1      1      1      1      1
MSCI   p      0,051  0,032  0,051  0,102  0,397  0,303
       Holm   0,859  0,575  0,859  1      1      1
EPU    p      0,186  0,210  0,130  0,273  0,608  0,191
       Holm   1      1      1      1      1      1
```

Não rejeitamos a hipótese de resposta zero a 10% após o ajuste por múltiplos testes. O resultado não comprova a exogeneidade, porque também é compatível com pouca precisão. Sem ajuste, o índice de emergentes cai no impacto, em h1 e em h3, e o VIX cai em h6. A rodada não separa o peso do Brasil no índice, uma piora de risco comum aos emergentes e uma contaminação do instrumento. O EPU, que no paper atual é significante a 90% de h1 a h3, deixa de ser significante em todos os horizontes. Das três séries, só o VIX entra na ortogonalização, como tendência de 65 pregões anterior ao anúncio, e de h1 em diante o teste não carrega restrição mecânica. Em h0, o VIX de fim de mês cobre em parte essa janela, e o teste desse horizonte não é uma checagem de todo independente. O p = 0,54 testa se o coeficiente da tendência do EPU é zero na regressão da surpresa. Ele indica ausência de poder preditivo naquela especificação, sem validar a exogeneidade.

Prefere que eu já atualize o artigo ou que aguarde as próximas rodadas?

Abraço,
Gabriel
