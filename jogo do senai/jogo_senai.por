programa
{
    inclua biblioteca Util --> util
    inclua biblioteca Tipos --> tipos

    // -------------------- CONSTANTES --------------------

    const inteiro LINHAS = 5
    const inteiro COLUNAS = 5
    const inteiro TOTAL_CASAS = 25

    const inteiro BATERIA_INICIAL = 100
    const inteiro CUSTO_RODADA = 10
    const inteiro PENALIDADE_RISCO = 3

    // -------------------- CENÁRIO --------------------

    cadeia cenario[5][5]
    inteiro nivel_das_casas[25]

    // -------------------- PERCENTUAIS --------------------

    real percentual_nivel_1 = 0.0
    real percentual_nivel_2 = 0.0
    real percentual_nivel_3 = 0.0

    inteiro fim_nivel_1 = 0
    inteiro fim_nivel_2 = 0

    // -------------------- POSIÇÕES --------------------

    inteiro casa_b05 = -1
    inteiro casa_b10 = -1
    inteiro casa_risco = -1
    inteiro casa_tesouro = -1

    // -------------------- ESTADO DO JOGO --------------------

    inteiro bateria = BATERIA_INICIAL
    inteiro creditos_obtidos = 0
    inteiro quantidade_rodadas = 0
    inteiro ultima_casa_visitada = 0

    logico tesouro_encontrado = falso

    funcao inicio()
    {
        mostrar_introducao()
        solicitar_percentuais()
        GerarCenario()
        jogar()
        mostrar_resultado_final()
    }

    funcao mostrar_introducao()
    {
        escreva("========================================\n")
        escreva("          JOGO CACA AO TESOURO          \n")
        escreva("========================================\n")
        escreva("O tabuleiro possui 25 casas (5 x 5).\n")
        escreva("Bateria inicial: ", BATERIA_INICIAL, " creditos.\n")
        escreva("Custo de cada rodada: ", CUSTO_RODADA, " creditos.\n")
        escreva("Encontre o tesouro antes da bateria acabar!\n\n")
    }

    /*
     * Solicita e valida os percentuais dos níveis.
     */
    funcao solicitar_percentuais()
    {
        logico percentuais_validos = falso
        real soma_percentuais

        enquanto (nao percentuais_validos)
        {
            escreva("Percentual do Nivel I: ")
            leia(percentual_nivel_1)

            escreva("Percentual do Nivel II: ")
            leia(percentual_nivel_2)

            escreva("Percentual do Nivel III: ")
            leia(percentual_nivel_3)

            soma_percentuais = percentual_nivel_1 +
                               percentual_nivel_2 +
                               percentual_nivel_3

            se (percentual_nivel_1 < 0.0 ou
                percentual_nivel_2 < 0.0 ou
                percentual_nivel_3 < 0.0)
            {
                escreva("\nValores invalidos!\n")
                escreva("Os percentuais nao podem ser negativos.\n\n")
            }
            senao se (soma_percentuais != 100.0)
            {
                escreva("\nValores invalidos!\n")
                escreva("A soma deve ser exatamente 100%.\n")
                escreva("Soma informada: ", soma_percentuais, "%\n\n")
            }
            senao se (
                arredondar_casas(
                    TOTAL_CASAS * percentual_nivel_1 / 100.0
                ) > 23
            )
            {
                escreva("\nConfiguracao invalida!\n")
                escreva("Devem existir pelo menos duas casas ")
                escreva("nos niveis II e III.\n\n")
            }
            senao
            {
                percentuais_validos = verdadeiro
                escreva("\nPercentuais cadastrados com sucesso!\n\n")
            }
        }
    }

    /*
     * Arredondamento convencional:
     * 6,2 vira 6 e 7,8 vira 8.
     */
    funcao inteiro arredondar_casas(real valor)
    {
        retorne tipos.real_para_inteiro(valor + 0.5)
    }

    /*
     * FUNÇÃO OBRIGATÓRIA
     *
     * Inicializa a matriz, calcula os níveis
     * e sorteia todos os elementos.
     */
    funcao GerarCenario()
    {
        inicializar_matriz()
        calcular_niveis()
        sortear_elementos()
    }

    funcao inicializar_matriz()
    {
        inteiro linha
        inteiro coluna

        para (linha = 0; linha < LINHAS; linha++)
        {
            para (coluna = 0; coluna < COLUNAS; coluna++)
            {
                cenario[linha][coluna] = "---"
            }
        }
    }

    funcao calcular_niveis()
    {
        inteiro casa

        fim_nivel_1 = arredondar_casas(
            TOTAL_CASAS * percentual_nivel_1 / 100.0
        )

        fim_nivel_2 = arredondar_casas(
            TOTAL_CASAS *
            (percentual_nivel_1 + percentual_nivel_2) /
            100.0
        )

        para (casa = 0; casa < TOTAL_CASAS; casa++)
        {
            se (casa < fim_nivel_1)
            {
                nivel_das_casas[casa] = 1
            }
            senao se (casa < fim_nivel_2)
            {
                nivel_das_casas[casa] = 2
            }
            senao
            {
                nivel_das_casas[casa] = 3
            }
        }
    }

    funcao sortear_elementos()
    {
        // Os bônus podem aparecer em qualquer nível.

        casa_b05 = sortear_casa_livre(
            0,
            TOTAL_CASAS - 1
        )

        colocar_conteudo(casa_b05, "B05")

        casa_b10 = sortear_casa_livre(
            0,
            TOTAL_CASAS - 1
        )

        colocar_conteudo(casa_b10, "B10")

        /*
         * Risco e tesouro não podem ficar no Nível I.
         */

        casa_risco = sortear_casa_livre(
            fim_nivel_1,
            TOTAL_CASAS - 1
        )

        colocar_conteudo(casa_risco, "RIS")

        casa_tesouro = sortear_casa_livre(
            fim_nivel_1,
            TOTAL_CASAS - 1
        )

        colocar_conteudo(casa_tesouro, "$$$")
    }

    /*
     * Repete o sorteio se a posição já estiver ocupada.
     */
    funcao inteiro sortear_casa_livre(
        inteiro primeira_casa,
        inteiro ultima_casa
    )
    {
        inteiro casa_sorteada

        faca
        {
            casa_sorteada = util.sorteia(
                primeira_casa,
                ultima_casa
            )
        }
        enquanto (conteudo_da_casa(casa_sorteada) != "---")

        retorne casa_sorteada
    }

    /*
     * Converte o índice linear para linha e coluna.
     */
    funcao colocar_conteudo(
        inteiro casa,
        cadeia conteudo
    )
    {
        inteiro linha
        inteiro coluna

        linha = casa / COLUNAS
        coluna = casa % COLUNAS

        cenario[linha][coluna] = conteudo
    }

    funcao cadeia conteudo_da_casa(inteiro casa)
    {
        inteiro linha
        inteiro coluna

        linha = casa / COLUNAS
        coluna = casa % COLUNAS

        retorne cenario[linha][coluna]
    }

    /*
     * Percorre sequencialmente as casas do tabuleiro.
     */
    funcao jogar()
    {
        inteiro casa_atual = 0
        cadeia conteudo

        escreva("\nCenario gerado com sucesso!\n")
        escreva("A busca pelo tesouro comecou!\n")

        enquanto (
            casa_atual < TOTAL_CASAS e
            bateria >= CUSTO_RODADA e
            nao tesouro_encontrado
        )
        {
            ultima_casa_visitada = casa_atual
            quantidade_rodadas = quantidade_rodadas + 1

            escreva("\n----------------------------------------\n")
            escreva("Rodada: ", quantidade_rodadas, "\n")
            escreva("Casa: ", casa_atual + 1, "\n")

            escreva(
                "Posicao: [",
                casa_atual / COLUNAS,
                ",",
                casa_atual % COLUNAS,
                "]\n"
            )

            /*
             * Primeiro ocorre o consumo normal da rodada.
             */
            DiminuirBateria()

            /*
             * Depois do consumo, verifica o conteúdo.
             */
            conteudo = conteudo_da_casa(casa_atual)

            se (conteudo == "B05")
            {
                escreva("Bonus de 5 creditos encontrado!\n")
                Bonus(5)
            }
            senao se (conteudo == "B10")
            {
                escreva("Bonus de 10 creditos encontrado!\n")
                Bonus(10)
            }
            senao se (conteudo == "RIS")
            {
                escreva("Casa de risco encontrada!\n")
                escreva("Penalidade de 3 creditos aplicada.\n")
                Risco()
            }
            senao se (conteudo == "$$$")
            {
                escreva("TESOURO ENCONTRADO!\n")
                tesouro_encontrado = verdadeiro
            }
            senao
            {
                escreva("Esta casa esta vazia.\n")
            }

            escreva(
                "Bateria atual: ",
                bateria,
                " creditos\n"
            )

            casa_atual = casa_atual + 1
        }

        se (
            nao tesouro_encontrado e
            bateria < CUSTO_RODADA
        )
        {
            escreva("\n----------------------------------------\n")
            escreva("Bateria insuficiente para uma nova rodada.\n")
            escreva("Sao necessarios pelo menos ")
            escreva(CUSTO_RODADA, " creditos.\n")
        }
    }

    /*
     * FUNÇÃO OBRIGATÓRIA
     *
     * Retira 10 créditos da bateria.
     */
    funcao DiminuirBateria()
    {
        bateria = bateria - CUSTO_RODADA
    }

    /*
     * FUNÇÃO OBRIGATÓRIA
     *
     * Recebe o bônus por parâmetro e adiciona
     * o valor à bateria e aos créditos obtidos.
     */
    funcao Bonus(inteiro valor_bonus)
    {
        bateria = bateria + valor_bonus

        creditos_obtidos = creditos_obtidos +
                           valor_bonus
    }

    /*
     * FUNÇÃO OBRIGATÓRIA
     *
     * Retira 3 créditos depois do custo da rodada.
     */
    funcao Risco()
    {
        bateria = bateria - PENALIDADE_RISCO
    }

    /*
     * Mostra as 25 casas da matriz.
     */
    funcao mostrar_cenario()
    {
        inteiro linha
        inteiro coluna

        para (linha = 0; linha < LINHAS; linha++)
        {
            para (coluna = 0; coluna < COLUNAS; coluna++)
            {
                escreva(cenario[linha][coluna], " ")
            }

            escreva("\n")
        }
    }

    /*
     * Converte o número do nível em romano.
     */
    funcao cadeia nome_nivel(inteiro numero_nivel)
    {
        se (numero_nivel == 1)
        {
            retorne "I"
        }
        senao se (numero_nivel == 2)
        {
            retorne "II"
        }
        senao
        {
            retorne "III"
        }
    }

    /*
     * Mostra os limites calculados automaticamente.
     */
    funcao mostrar_limites_dos_niveis()
    {
        escreva("\nLimites calculados:\n")

        se (fim_nivel_1 > 0)
        {
            escreva(
                "Nivel I: casas 01 ate ",
                fim_nivel_1,
                "\n"
            )
        }
        senao
        {
            escreva("Nivel I: nenhuma casa\n")
        }

        se (fim_nivel_2 > fim_nivel_1)
        {
            escreva(
                "Nivel II: casas ",
                fim_nivel_1 + 1,
                " ate ",
                fim_nivel_2,
                "\n"
            )
        }
        senao
        {
            escreva("Nivel II: nenhuma casa\n")
        }

        se (fim_nivel_2 < TOTAL_CASAS)
        {
            escreva(
                "Nivel III: casas ",
                fim_nivel_2 + 1,
                " ate 25\n"
            )
        }
        senao
        {
            escreva("Nivel III: nenhuma casa\n")
        }
    }

    /*
     * Apresenta o resultado completo solicitado.
     */
    funcao mostrar_resultado_final()
    {
        escreva("\n\n========== RESULTADO DO JOGO ==========\n\n")

        mostrar_cenario()

        escreva(
            "\nBateria restante: ",
            bateria,
            " creditos\n"
        )

        escreva(
            "Creditos obtidos: ",
            creditos_obtidos,
            " creditos\n"
        )

        escreva(
            "Nivel atingido: ",
            nome_nivel(
                nivel_das_casas[ultima_casa_visitada]
            ),
            "\n"
        )

        se (tesouro_encontrado)
        {
            escreva("Tesouro encontrado: SIM\n")
        }
        senao
        {
            escreva("Tesouro encontrado: NAO\n")
        }

        escreva("\nPosicao do risco:\n")
        escreva("Casa: ", casa_risco + 1, "\n")

        escreva(
            "Posicao na matriz: [",
            casa_risco / COLUNAS,
            ",",
            casa_risco % COLUNAS,
            "]\n"
        )

        escreva(
            "\nQuantidade de rodadas: ",
            quantidade_rodadas,
            "\n"
        )

        escreva(
            "Ultima casa visitada: ",
            ultima_casa_visitada + 1,
            "\n"
        )

        mostrar_limites_dos_niveis()

        escreva("\n========================================\n")
    }
}