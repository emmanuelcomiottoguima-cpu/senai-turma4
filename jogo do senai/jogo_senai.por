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

    funcao inicio()
    {
        mostrar_introducao()
        solicitar_percentuais()
        GerarCenario()
        mostrar_cenario()
        mostrar_limites_dos_niveis()
        mostrar_posicoes_sorteadas()
        testar_bateria()
    }

    funcao mostrar_introducao()
    {
        escreva("========================================\n")
        escreva("          JOGO CACA AO TESOURO          \n")
        escreva("========================================\n")
        escreva("O tabuleiro possui 25 casas (5 x 5).\n")
        escreva("Bateria inicial: ", BATERIA_INICIAL, " creditos.\n")
        escreva("Custo de cada rodada: ", CUSTO_RODADA, " creditos.\n\n")
    }

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
                escreva("\nOs percentuais nao podem ser negativos.\n\n")
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

    funcao inteiro arredondar_casas(real valor)
    {
        retorne tipos.real_para_inteiro(valor + 0.5)
    }

    /*
     * FUNÇÃO OBRIGATÓRIA
     *
     * Inicializa a matriz, calcula os níveis
     * e sorteia os elementos.
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
        casa_b05 = sortear_casa_livre(0, TOTAL_CASAS - 1)
        colocar_conteudo(casa_b05, "B05")

        casa_b10 = sortear_casa_livre(0, TOTAL_CASAS - 1)
        colocar_conteudo(casa_b10, "B10")

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

    funcao colocar_conteudo(inteiro casa, cadeia conteudo)
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
     * FUNÇÃO OBRIGATÓRIA
     *
     * Retira 10 créditos da bateria.
     * Essa função será chamada uma vez por rodada.
     */
    funcao DiminuirBateria()
    {
        bateria = bateria - CUSTO_RODADA
    }

    /*
     * FUNÇÃO OBRIGATÓRIA
     *
     * Recebe o valor do bônus por parâmetro.
     * O valor é adicionado à bateria e ao total
     * de créditos obtidos pelo jogador.
     */
    funcao Bonus(inteiro valor_bonus)
    {
        bateria = bateria + valor_bonus
        creditos_obtidos = creditos_obtidos + valor_bonus
    }

    /*
     * FUNÇÃO OBRIGATÓRIA
     *
     * Retira 3 créditos da bateria.
     * Essa penalidade será aplicada depois
     * do consumo normal da rodada.
     */
    funcao Risco()
    {
        bateria = bateria - PENALIDADE_RISCO
    }

    /*
     * Teste temporário das funções de bateria.
     *
     * Esta função será removida no próximo commit,
     * quando for criado o percurso verdadeiro do jogo.
     */
    funcao testar_bateria()
    {
        escreva("\n========== TESTE DA BATERIA ==========\n\n")

        escreva("Bateria inicial: ", bateria, "\n")

        DiminuirBateria()
        escreva("Depois de uma rodada: ", bateria, "\n")

        Bonus(5)
        escreva("Depois do Bonus(5): ", bateria, "\n")

        Bonus(10)
        escreva("Depois do Bonus(10): ", bateria, "\n")

        Risco()
        escreva("Depois do Risco(): ", bateria, "\n")

        escreva("Creditos obtidos: ", creditos_obtidos, "\n")
        escreva("\n======================================\n")
    }

    funcao mostrar_cenario()
    {
        inteiro linha
        inteiro coluna

        escreva("========== CENARIO GERADO ==========\n\n")

        para (linha = 0; linha < LINHAS; linha++)
        {
            para (coluna = 0; coluna < COLUNAS; coluna++)
            {
                escreva(cenario[linha][coluna], " ")
            }

            escreva("\n")
        }

        escreva("\n====================================\n")
    }

    funcao mostrar_limites_dos_niveis()
    {
        escreva("\n========== LIMITES DOS NIVEIS ==========\n\n")

        se (fim_nivel_1 > 0)
        {
            escreva("Nivel I: casas 01 ate ", fim_nivel_1, "\n")
            escreva("Quantidade: ", fim_nivel_1, " casas\n\n")
        }
        senao
        {
            escreva("Nivel I: nenhuma casa\n\n")
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

            escreva(
                "Quantidade: ",
                fim_nivel_2 - fim_nivel_1,
                " casas\n\n"
            )
        }
        senao
        {
            escreva("Nivel II: nenhuma casa\n\n")
        }

        se (fim_nivel_2 < TOTAL_CASAS)
        {
            escreva(
                "Nivel III: casas ",
                fim_nivel_2 + 1,
                " ate 25\n"
            )

            escreva(
                "Quantidade: ",
                TOTAL_CASAS - fim_nivel_2,
                " casas\n"
            )
        }
        senao
        {
            escreva("Nivel III: nenhuma casa\n")
        }

        escreva("\n========================================\n")
    }

    funcao mostrar_posicoes_sorteadas()
    {
        escreva("\n========== POSICOES SORTEADAS ==========\n\n")
        escreva("Bonus B05: Casa ", casa_b05 + 1, "\n")
        escreva("Bonus B10: Casa ", casa_b10 + 1, "\n")
        escreva("Risco RIS: Casa ", casa_risco + 1, "\n")
        escreva("Tesouro: Casa ", casa_tesouro + 1, "\n")
        escreva("\n========================================\n")
    }
}