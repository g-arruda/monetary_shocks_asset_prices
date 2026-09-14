Bom dia, Gabriel

Excelente atualização, você rodou exatamente os testes que poderiam ter confirmado sua hipótese original e reportou com transparência quando o resultado foi na direção contrária. Vamos por partes, porque há três questões distintas aqui e cada uma pede um tratamento diferente.

1) Sobre a hipótese de subestimação por correlação intra-bloco

A poda reduziu o Bai-Ng, na direção oposta à prevista pela hipótese de Boivin-Ng, e a divergência com AH/ABC aumentou. Isso derruba, pelo menos nesta aplicação específica, o mecanismo que havíamos levantado como explicação para a divergência entre estimadores. Não vamos mais usar essa história como justificativa central da especificação. Dito isso, vale você considerar uma explicação alternativa e mais mundana para o resultado: remover séries do painel, mesmo que redundantes, reduz o tamanho efetivo de N, e o Bai-Ng é mecanicamente sensível a N e T na seleção de r. É possível que a queda para r=3 reflita perda de potência para detectar fatores, não confirmação de que a correlação não inflava nada. As duas explicações não são mutuamente exclusivas, e não precisamos resolver isso de forma definitiva agora. Sugiro reportar esse exercício no artigo como um teste de robustez que você rodou e que não confirmou o mecanismo de Boivin-Ng nesta aplicação, sendo honesto quanto a isso, e seguir adiante com uma justificativa de especificação que não dependa mais dessa história.

2) Sobre a restrição de invertibilidade e a escolha da especificação principal

Este é o achado mais importante do seu email, porque muda a estrutura da nossa estratégia. A restrição hac_dim < T que você encontrou inviabiliza r=q=8 como especificação principal (exceto com p=1, o que não é desejável). Isso significa que a comparação direta com Alessi & Kerssenfischer via r=q=8 simplesmente não é viável dado o tamanho da sua amostra, e precisamos de um princípio novo para escolher a especificação principal, um que não dependa de replicar o valor exato do benchmark.

Aqui a passagem do Stock e Watson (2016) que você encontrou é útil, mas por um motivo ligeiramente diferente do que você propôs. Não é uma boa justificativa para usar r=q=8 (que já vimos ser inviável); é uma ótima justificativa para o princípio geral de fixar q=r deliberadamente, com base no argumento de que sobre-especificar o espaço de fatores dinâmicos garante que ele englobe os choques de interesse. Ou seja: mantenha a lógica de q=r, mas aplicada ao teto viável, r=q=5, não a 8. Isso preserva exatamente a estrutura que eu havia sugerido antes (uma regra pré-especificada, não uma escolha pós-hoc pela força do instrumento), só que recalibrada para a restrição que você descobriu.

Preciso que você verifique uma coisa antes de fecharmos isso: você reportou que (5,2) fica abaixo do limiar de Anderson-Rubin, mas não disse explicitamente se (5,5) cruza esse limiar. Essa é a checagem decisiva. Se q=r=5 tiver instrumento forte o suficiente, essa vira a especificação principal, com a citação de Stock-Watson (2016) como justificativa central, e a atual tabela de sensibilidade (q variando de 2 a 5, r fixo em 5) vira a robustez.

3) Sobre a divergência entre amostra completa e pré-covid

O padrão que você descreveu, robustez quase perfeita na janela pré-covid e sensibilidade a q na amostra completa, tem uma explicação bem documentada na literatura antes de tratarmos isso como uma fragilidade permanente do método: séries macro em 2020 costumam ter outliers extremos que distorcem a estimação de modelos de séries temporais, incluindo fatores dinâmicos. Veja Lenza e Primiceri (2022, Journal of Applied Econometrics, 37(4), 688-699), "How to Estimate a Vector Autoregression After March 2020", que trata exatamente desse problema em VARs, com implicações diretas para qualquer modelo que dependa de covariâncias estimadas em amostra cheia. Antes de aceitar que a amostra completa é realmente instável, vale testar se a instabilidade desaparece ao tratar adequadamente as observações de 2020 (a abordagem mais simples é uma correção de heterocedasticidade específica para esse período, na linha do que Lenza-Primiceri propõem, ou alternativamente uma dummy para o período mais extremo). Se a robustez pré-covid se estender à amostra completa depois desse ajuste, isso fortalece bastante o artigo, porque explica a divergência por um fenômeno amplamente documentado, em vez de deixá-la como uma fraqueza não resolvida da metodologia.

Próximos passos coordenados:

1) Verificar se a especificação (5,5) cruza o limiar mínimo de Anderson-Rubin. Se sim, essa passa a ser a especificação principal, com a citação de Stock-Watson (2016) como justificativa pré-especificada.
2) Reportar o exercício de poda como robustez que não confirmou a hipótese de Boivin-Ng nesta aplicação, com a ressalva sobre perda de N como explicação alternativa.
3) Implementar a correção para outliers de 2020 na linha de Lenza-Primiceri (2022) e reavaliar se a sensibilidade a q na amostra completa diminui.
4) Uma vez estabilizada a especificação principal, refazer a tabela de sensibilidade (q = 2,...,5, r=5 fixo) como robustez, já em ambas as janelas (completa ajustada e pré-covid).

Estamos avançando. Aguardo os próximos resultados.

Abrs.,