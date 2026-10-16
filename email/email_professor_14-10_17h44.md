Boa tarde, Gabriel.

Gabriel, obrigado, são boas perguntas. Esses pontos precisam ser resolvidos antes de interpretarmos a comparação diária como uma resposta ao anúncio. Vamos fazer isso com algumas regras claras, sem abrir outra rodada ampla.

1) Câmbio: Eu não usaria o fuso informado pela API como confirmação do horário da cotação. Ele pode indicar só a convenção de apresentação da série, sem identificar o instante do preço. Também não concluiria, só pelo horário presumido, que a cotação resulta de poucos negócios. Se você já tiver acesso a uma série de câmbio à vista com horário de referência documentado, prefira essa fonte para o exercício de evento.
Se não tiver, use a PTAX de venda do BCB como diagnóstico adicional. A PTAX de quarta-feira é apurada antes do comunicado, e a do primeiro dia útil seguinte o sucede. Confirme isso nas datas da amostra, porque o horário de divulgação do comunicado mudou ao longo do tempo. A PTAX não é fechamento nem medida intradiária. Descreva esse exercício como uma resposta em janela diária mais ampla, que também incorpora outras notícias.

Mantenha o Yahoo para comparação com a série atual, mas não o apresente como uma janela estreita comprovadamente anterior e posterior ao anúncio enquanto o horário permanecer desconhecido. Com ele, a comparação da observação do dia anterior à reunião com a do primeiro dia útil posterior ajuda a garantir que o intervalo abranja o anúncio, embora amplie a exposição a outras notícias.

Se você me passar as datas de cinco a dez reuniões, posso pedir a um conhecido com acesso à Bloomberg a cotação intradiária do dólar nos horários dos anúncios. Isso serviria só para identificar a convenção do Yahoo, sem trocar a fonte.

Não precisamos trocar agora a série do DFM. Primeiro confira se a apreciação encontrada depende da fonte ou da definição da janela.

3) Reuniões seguidas de feriado: Não deixe essas reuniões automaticamente com surpresa zero. Zero é adequado para um mês sem reunião ou para uma surpresa efetivamente medida como zero; ausência de observação é outro caso.

Primeiro, identifique o motivo de cada exclusão. Um feriado nos EUA não implica que o DI não tenha sido negociado no Brasil. Se o DI tem observações válidas antes e depois da decisão, a ausência de CDS ou de algum controle não deve, por si só, transformar a surpresa monetária em zero. Cada série precisa seguir seu calendário.

Nas reuniões em que o DI realmente só volta a ser observado mais tarde, calcule a medida usando a última observação anterior e a primeira posterior válida, conferindo o contrato e marcando a duração da janela. Essa medida incorpora mais tempo e outras notícias: apresente sua inclusão como sensibilidade, ao lado da amostra com janela habitual.

Se alguma surpresa continuar indisponível, trate-a como ausente. No DFM, mantenha o mês na amostra dinâmica, mas retire-o dos momentos de identificação que exigem o instrumento. Se houver mais de uma reunião no mês, não use uma soma incompleta como se fosse o instrumento mensal completo. Na regressão mensal simples, o mês sem instrumento observado também não deve entrar como zero.

Se a recuperação das reuniões mudar a amostra usada na ortogonalização, recalcule essa etapa; não acrescente as novas observações ao instrumento ortogonalizado como se a projeção anterior continuasse necessariamente válida.

Entrega desta conferência: Não é necessário repetir agora todos os exercícios de robustez. Primeiro precisamos verificar se essas correções mudam o sinal, a magnitude ou a precisão dos resultados centrais. Sugiro seguir esta ordem e me enviar o que ficar pronto em cada etapa, sem esperar tudo:

1) Tabela das reuniões afetadas, com os horários conhecidos ou desconhecidos, as datas pré e pós usadas em cada mercado, os feriados e a duração das janelas.

2) Câmbio: a comparação corrigida (PTAX e Yahoo, nas janelas descritas acima).

3) CDS: a janela ampliada, com as duas mudanças adjacentes.

4) Reuniões recuperadas: os resultados com e sem elas, apresentados lado a lado.

A apreciação diária relatada anteriormente deve permanecer provisória até essa conferência.