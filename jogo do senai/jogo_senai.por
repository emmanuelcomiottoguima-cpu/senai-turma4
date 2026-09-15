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

    // -------------------- POSIÇÕES SORTEADAS --------------------

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
        mostrar_resumo_da_partida()
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
     * Solicita os percentuais até que os valores
     * informados sejam válidos.
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
     * Aplica o arredondamento convencional.
     *
     * Exemplos:
     * 6,2 será convertido para 6.
     * 7,8 será convertido para 8.
     */
    funcao inteiro arredondar_casas(real valor)
    {
        retorne tipos.real_para_inteiro(valor + 0.5)
    }

    /*
     * FUNÇÃO OBRIGATÓRIA
     *
     * Cria o cenário completo do jogo.
     */
    funcao GerarCenario()
    {
        inicializar_matriz()
        calcular_niveis()
        sortear_elementos()
    }

    /*
     * Coloca "---" em todas as 25 casas.
     */
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

    /*
     * Calcula os limites e registra o nível
     * correspondente a cada casa.
     */
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

    /*
     * Sorteia os dois bônus, o risco e o tesouro.
     */
    funcao sortear_elementos()
    {
        // Os bônus podem estar em qualquer nível.

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
         * Risco e tesouro começam após a última
         * casa pertencente ao Nível I.
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
     * Repete o sorteio enquanto a casa
     * escolhida não estiver vazia.
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
     * Converte o índice da casa para linha
     * e coluna antes de colocar o conteúdo.
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

    /*
     * Retorna o conteúdo armazenado na casa.
     */
    funcao cadeia conteudo_da_casa(inteiro casa)
    {
        inteiro linha
        inteiro coluna

        linha = casa / COLUNAS
        coluna = casa % COLUNAS

        retorne cenario[linha][coluna]
    }

    /*
     * Executa o percurso sequencial da Casa 01
     * até o tesouro ou o final da bateria.
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
             * O custo normal é aplicado antes
             * de verificar o conteúdo da casa.
             */
            DiminuirBateria()

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

                /*
                 * O risco é aplicado depois do
                 * consumo normal da rodada.
                 */
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
     * Desconta 10 créditos da bateria.
     */
    funcao DiminuirBateria()
    {
        bateria = bateria - CUSTO_RODADA
    }

    /*
     * FUNÇÃO OBRIGATÓRIA
     *
     * Recebe o valor do bônus por parâmetro
     * e o converte em bateria.
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
     * Aplica a penalidade de 3 créditos.
     */
    funcao Risco()
    {
        bateria = bateria - PENALIDADE_RISCO
    }

    /*
     * Mostra a matriz completa.
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
     * Converte o número do nível em
     * algarismo romano.
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
     * Mostra o resumo provisório da partida.
     *
     * No Commit 6 será criado o resultado
     * completo solicitado no enunciado.
     */
    funcao mostrar_resumo_da_partida()
    {
        escreva("\n\n========== RESUMO DA PARTIDA ==========\n\n")

        escreva(
            "Ultima casa visitada: ",
            ultima_casa_visitada + 1,
            "\n"
        )

        escreva(
            "Nivel atingido: ",
            nome_nivel(
                nivel_das_casas[ultima_casa_visitada]
            ),
            "\n"
        )

        escreva(
            "Quantidade de rodadas: ",
            quantidade_rodadas,
            "\n"
        )

        escreva(
            "Bateria restante: ",
            bateria,
            " creditos\n"
        )

        escreva(
            "Creditos obtidos: ",
            creditos_obtidos,
            " creditos\n"
        )

        se (tesouro_encontrado)
        {
            escreva("Tesouro encontrado: SIM\n")
        }
        senao
        {
            escreva("Tesouro encontrado: NAO\n")
        }

        escreva("\n=======================================\n")
    }
}