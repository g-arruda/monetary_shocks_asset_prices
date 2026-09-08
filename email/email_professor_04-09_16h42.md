Boa tarde, Gabriel.

Muito bom trabalho nessa investigação, a sua hipótese sobre a correlação dentro dos blocos subestimando r e q está bem fundamentada, e a literatura já documenta exatamente esse mecanismo. Vamos por partes.

 Sobre a hipótese. Boivin & Ng (2006, Journal of Econometrics 132(1), 169-194), Are More Data Always Better for Factor Analysis?, tratam precisamente desse cenário, um bloco com muitas séries altamente correlacionadas (oversampling data from particular groups, na frase deles) distorce a extração de fatores, mesmo com um painel grande. A conclusão central do artigo é que tamanho da amostra sozinho não garante boas estimativas, a composição importa tanto quanto o tamanho. Isso confirma teoricamente a sua intuição.

 Qual das duas opções seguir. Diante disso, eu iria com a sua opção (1): reduzir as variáveis altamente correlacionadas, e não a (2). Adicionar mais variáveis sem critério pode piorar exatamente o problema que você identificou, se as novas séries também forem correlacionadas com blocos já superrepresentados. Sugiro um critério sistemático, não remoção ad hoc: dentro de cada bloco, calcule a matriz de correlação par a par e, para grupos de séries com correlação acima de um limiar (por exemplo, 0,9), mantenha apenas uma série representativa do grupo (ou use a média). Isso é muito mais defensável numa seção de dados do que uma poda informal.

 Uma checagem direta da hipótese, para fortalecer o argumento. Além de Bai-Ng, rode pelo menos mais um estimador de r:

1)  Ahn & Horenstein (2013, Econometrica 81(3), 1203-1227), Eigenvalue Ratio Test for the Number of Factors, baseado na razão de autovalores adjacentes, com propriedades diferentes de Bai-Ng em amostra finita;
2)  Alessi, Barigozzi & Capasso (2010,  Statistics and Probability Letters 80, 1806-1813), Improved Penalization for Determining the Number of Factors in Approximate Factor Models, uma correção explícita do Bai-Ng para problemas de amostra finita, ainda mais diretamente relevante ao seu caso.

Se esses dois derem r visivelmente maior que 5, isso vira evidência direta de subestimação, bem mais forte no artigo do que só mostrar que o instrumento fica mais forte quando r,q aumentam.

 Um ponto de cautela importante, antes de fechar a especificação. Escolher (r,q) com base em qual combinação dá o instrumento mais forte se aproxima perigosamente de specification search, exatamente o tipo de prática que a literatura de instrumento fraco critica. Para evitar essa leitura, sugiro estruturar assim:

1)  Especificação principal: r=q=8. Não porque maximiza a força do instrumento, mas porque é exatamente o que Alessi & Kerssenfischer (2019) usam no artigo de comparação direta, você mesmo já achou essa justificativa na nota de rodapé 4 deles. Isso dá uma razão limpa e pré-especificada, garantindo comparação direta com o benchmark.
2) Robustez: reporte a tabela de sensibilidade que você já fez, (5,2), (7,5), (8,8), mas enquadrada como confirmação de que os sinais são estáveis e só a magnitude varia, não como o processo de escolha da especificação principal.
3) Reporte explicitamente que (5,2) fica abaixo do mínimo para as bandas de Anderson-Rubin, isso reforça, por si só, por que não usamos a estimativa crua de Bai-Ng/Amengual-Watson como especificação principal.

Com essa estrutura, uma possível fragilidade (parece que escolhemos o que funcionou melhor) vira um argumento honesto e bem amarrado: a literatura de comparação já usa esse valor, nossos próprios dados são consistentes com a hipótese de subestimação por correlação, e os resultados são robustos ao longo de todo o intervalo plausível.

 Coordenadas para os próximos passos:
1)  Rodar Ahn-Horenstein e Alessi-Barigozzi-Capasso para r, comparando com Bai-Ng.
2)  Construir a matriz de correlação dentro de cada bloco e identificar grupos de séries redundantes (limiar sugerido: 0,9) para poda sistemática.
3)  Refazer a seleção de r,q no painel podado e conferir se a divergência em relação a Bai-Ng diminui.
4)  Adotar r=q=8 como especificação principal (com a justificativa do item 1 da estrutura acima), mantendo a tabela de sensibilidade como robustez.
5)  Continuar a implementação das bandas de Anderson-Rubin para o DFM, assim que estiver pronta, aplique tanto à especificação principal quanto à (5,2), para deixar explícito visualmente por que essa última não é adequada.

Ótimo progresso, a tabela de heterocedasticidade e a implementação das bandas AR para o DFM são exatamente os pontos que havíamos identificado como mais críticos. Aguardo os resultados da poda e dos estimadores alternativos de r.

Abrs.,
João  