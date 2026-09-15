# Caça ao Tesouro - Portugol Webstudio

Jogo acadêmico desenvolvido em Portugol com uma matriz 5x5. O jogador percorre as casas em sequência até encontrar o tesouro ou ficar sem os 10 créditos necessários para iniciar uma nova rodada.

## Como executar

1. Acesse [Portugol Webstudio](https://portugol.dev/).
2. Crie um novo arquivo/programa.
3. Apague o código de exemplo.
4. Copie todo o conteúdo de `caca_ao_tesouro.por` e cole no editor.
5. Clique em **Executar**.
6. Informe três percentuais cuja soma seja exatamente 100. Exemplo: `25`, `35` e `40`.

## Elementos do cenário

| Código | Significado |
| --- | --- |
| `---` | Casa vazia |
| `B05` | Bônus de 5 créditos |
| `B10` | Bônus de 10 créditos |
| `RIS` | Risco: perde 3 créditos |
| `$$$` | Tesouro |

## Regras implementadas

- matriz 5x5, com índices de 0 a 4;
- percurso sequencial da Casa 01 `[0,0]` até a Casa 25 `[4,4]`;
- percentuais validados e limites calculados automaticamente;
- arredondamento convencional;
- 21 casas vazias e quatro elementos sorteados sem sobreposição;
- bônus em qualquer nível;
- risco e tesouro somente nos níveis II e III;
- bateria inicial de 100 créditos e custo de 10 por rodada;
- bônus aplicados automaticamente;
- risco aplicado depois do consumo normal;
- encerramento por tesouro ou bateria insuficiente;
- exibição completa do resultado final;
- uso efetivo das funções obrigatórias `GerarCenario()`, `DiminuirBateria()`, `Bonus()` e `Risco()`.

## Observação sobre a validação

Além de exigir soma igual a 100%, o programa impede que o Nível I ocupe mais de 23 casas. Essa proteção é necessária porque risco e tesouro precisam ficar, em casas diferentes, nos níveis II ou III. Sem ela, certas entradas poderiam tornar o sorteio impossível.

## Arquivos

- `caca_ao_tesouro.por`: código final para o Portugol Webstudio;
- `GUIA_6_COMMITS.md`: divisão do desenvolvimento em seis commits;
- `README.md`: documentação do jogo.
