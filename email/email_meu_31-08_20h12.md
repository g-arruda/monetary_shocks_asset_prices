Este arquivo é uma troca de mensagens por email que estou tendo com meu professor, onde a primeira pergunta/mensagem é uma resposta dos questionamentos do arquivo `resposta.md`

## pergunta 1
1. Esse é um problema de versão, esqueci de atualizar essas seções após a mudança no modelo.
Professor: Está bem, obrigado.

## pergunta 2
2. Hoje não se tem na literatura um mecanismo de inferência robusta a instrumento fraco aplicado aos modelos DFM. Montiel Olea et al. aplicam a um modelo VAR pequeno e a aplicação disso a um modelo DFM requer uma engenharia matemática que não é trivial, e não sei se tenho capacidade.


----

Professor: Não sei se é viável e quão complicado a implementação, mas há pelo menos duas referências que tratam desse ponto: 

    1) Kapetanios (2016, Journal of Applied Econometrics), Factor-Based Identification-Robust Inference in IV Regressions, combina exatamente redução de dimensão via fatores com testes robustos a instrumento fraco (incluindo Anderson-Rubin). 
    2) Além disso, a literatura de proxy-SVAR com instrumento fraco já cobre explicitamente o caso de um único instrumento identificando um único choque, que é exatamente a situação que nos deparamos aqui (o choque Copom), via Jentsch & Lunsford (2019, 2022), com bandas de confiança grid moving-block-bootstrap Anderson-Rubin, generalizando Montiel Olea et al. (2021) para além do VAR pequeno original.

    O ponto técnico chave: o difícil não é o tamanho do painel (106 séries), é o VAR dos fatores (que tem dimensão pequena, tipo 4 a 8 fatores). O Anderson-Rubin robusto se aplicaria a esse VAR de fatores, objeto pequeno, do mesmo tipo que Montiel Olea et al. já tratam, e depois a banda de confiança dos fatores se propaga pelas loadings (transformação linear, trivial) até chegar nas séries observáveis. Isso não é zero trabalho, mas me parece bem menos engenharia matemática não trivial do que você está enxergando, é mais trabalho de implementação computacional do que teoria nova.

    - Minha sugestão, em ordem de esforço:
        1) Mínimo (reenquadrar o que já existe): a Seção 5.1 já reporta bandas AR-robustas para o VAR de benchmark. Em vez de deixar isso como só uma comparação de robustez, reposicionar explicitamente: não estendemos formalmente inferência robusta a instrumento fraco ao DFM completo, mas confirmamos que um VAR menor com as variáveis-chave, sob inferência robusta, entrega conclusões qualitativamente semelhantes, e citar Kapetanios (2016) e Jentsch & Lunsford (2022) como a fronteira metodológica reconhecida. Isso é reescrita, não pesquisa nova.

        2) Se houver fôlego: tentar a extensão real, mas aplicada ao VAR dos fatores (dimensão pequena), não ao painel inteiro, pode ser mais tratável do que você está achando.

    Recomendo que você pelo menos dê uma olhada nesses dois papers antes de descartar a ideia, isso pra ver o quão complicado é, eventualmente até pode ter algum pacote pronto, também não tenho certeza de que a extensão seja imediata sem ajustes. 
  
----

Eu: Vou ler com calma as duas literaturas sugeridas e tentar aplicar as bandas AR no VAR dos fatores. Minha dúvida é que Montiel Olea et al. provam o teorema para variáveis observáveis e não estimadas como os fatores, isso seria um problema ou algo defensável?


----

Professor:



## pergunta 3
3. DLSP, DBGG e NFSP primária caem no início e só voltam a subir depois de cerca de dois anos, enquanto as expectativas de inflação, Selic e câmbio sobem e a de PIB cai antes de uma reversão conjunta. Só que a NFSP primária exclui juros e efeito cambial, e a DLSP incorpora ativos como reservas, então parte do movimento pode vir da forma de contabilização das séries. Vou por no arquivo .tex para facilitar para o senhor o efeito do choque e também vou incluir as séries de expectativa fiscal no painel para ver o efeito sobre a percepção de sustentabilidade da dívida.

----

professor: Na verdade, isso me parece um resultado bom, só precisa de mais uma camada de decomposição antes de aparecer no texto. O que você encontrou é interessante, não problemático: dívida caindo no início e revertendo só depois de ~2 anos, junto com expectativas de inflação/Selic/câmbio subindo e PIB caindo antes da reversão conjunta. Duas coisas para fazer antes de escrever isso no artigo:

    1) A hipótese do efeito cambial é testável diretamente, não precisa ficar como especulação. O BCB publica mensalmente a decomposição da DLSP por fatores condicionantes (resultado primário, juros apropriados, ajuste cambial sobre dívida e reservas indexadas, reconhecimento de dívidas, outros ajustes), está no SGS/IPEADATA. Como o real deprecia ~3,7% no impacto, e reservas internacionais em dólar entram líquidas na DLSP, uma depreciação mecanicamente reduz a DLSP (reservas em BRL valem mais) mesmo sem nenhuma melhora fiscal de fato. Você pode rodar a mesma resposta ao impulso para essa série de ajuste cambial especificamente e ver se ela explica a queda inicial da DLSP. Isso transforma uma hipótese não testada em evidência direta.
    2) Atenção ao sinal do NFSP primário, cai pode significar déficit menor (melhora) ou piora, dependendo de qual convenção de sinal você está usando na série do BCB. Vale confirmar  exatamente isso antes de interpretar qualquer coisa, porque a leitura econômica se inverte dependendo disso.

    A sua ideia de incluir as expectativas fiscais do Focus é a correção certa, e mais importante que os itens acima: prêmio de risco é forward-looking, então o que expectativas de sustentabilidade fiscal fazem importa mais para o mecanismo do que o estoque de dívida realizado (que é mecânico e ruidoso). Eu priorizaria isso como o resultado central dessa seção, com a decomposição cambial como apoio/robustez.

----

Eu:
     1) Apenas encontrei as séries DLSP (real, dolar o %PIB) diferenciada entre setor e internet/externa, com granularidade entre: gov, estao. Qual o senhor esta se referindo?
     2) Creio que o sinal indica uma melhora, estou usando a série 4649 do SGS/BCB
     3) Vou incluir as séries e retorno com o resultado

----

Professor:
    1) A decomposição que eu tinha em mente não é a série de estoque de DLSP que você encontrou (por setor/interna-externa), é uma tabela de fluxo, publicada na Nota de Estatísticas Fiscais do BCB, historicamente a Tabela 6 "Evolução da dívida líquida, Fatores    condicionantes", com linhas para necessidade de financiamento, ajuste cambial, reconhecimento de dívidas e outros ajustes metodológicos. Procure por fatores condicionantes (não DLSP) no SGS, ou vá direto à publicação periódica do BCB (Estatísticas => Finanças Públicas => Notas de Estatísticas Fiscais), pode ser que venha como planilha da nota, não necessariamente como série individual codificada no SGS.
    
    2) Confirmado: a série 4649 é literalmente NFSP sem desvalorização cambial, resultado primário, e a definição oficial do BCB é Necessidades de Financiamento, ou seja, é uma medida de necessidade de financiamento/déficit, não de superávit. Uma queda nessa série significa menor necessidade de financiamento, isto é, melhora fiscal. Sua leitura está certa.


## pergunta 4
4. Eu cheguei a tentar aplicar o exercício, mas não deu certo, pois na agregação dos dados mensais ocorre uma diluição na variância (minha hipótese), fazendo com que a condição do posto desaparecesse, impossibilitando a identificação.

----

Professor: O não deu certo já é a resposta, só falta escrever. A meu ver, isso é uma notícia melhor do que você percebeu. A diluição de variância que você suspeita ao agregar para mensal é exatamente o motivo pelo qual a literatura de identificação por heterocedasticidade (Rigobon 2003; Rigobon & Sack 2004) insiste em janelas curtas/intradiárias ao redor do anúncio, a agregação temporal dilui a descontinuidade de variância que a identificação depende, e pode quebrar a condição de posto. Isso é um argumento causal melhor do que o parágrafo especulativo que eu tinha sugerido, porque é evidência direta, não conjectura. Sugiro escrevermos um parágrafo curto (ou nota de rodapé) relatando exatamente essa tentativa e esse diagnóstico, não como não conseguimos, mas como testamos diretamente e encontramos uma razão mecânica pela qual a frequência da identificação importa. Isso fecha a objeção de um parecerista com muito mais força do que eu tinha originalmente proposto.

----

Eu: Vou incluir o parágrafo mais a tabela no apêndice.

----

Professor: Só uma sugestão adicional, se possível, reporte também a estatística do teste de posto (ou o determinante da matriz relevante) antes e depois da agregação para mensal, lado a lado, isso torna o argumento a agregação dilui a variância e quebra a condição de posto visualmente imediato para um parecerista, em vez de exigir que ele confie só na descrição textual. 



## pergunta 5
5. Vou consertar o erro no LaTeX e rodar ambos os modelos com a mesma defasagem.
Resp: Está bem. 

