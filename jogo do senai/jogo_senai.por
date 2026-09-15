programa
{
    inclua biblioteca Tipos --> tipos

    // -------------------- CONSTANTES --------------------

    const inteiro LINHAS = 5
    const inteiro COLUNAS = 5
    const inteiro TOTAL_CASAS = 25

    // -------------------- MATRIZES E VETORES --------------------

    // Matriz principal do cenário.
    cadeia cenario[5][5]

    // Armazena o nível correspondente a cada uma das 25 casas.
    inteiro nivel_das_casas[25]

    // -------------------- PERCENTUAIS --------------------

    real percentual_nivel_1 = 0.0
    real percentual_nivel_2 = 0.0
    real percentual_nivel_3 = 0.0

    // Quantidade acumulada de casas até o final de cada nível.
    inteiro fim_nivel_1 = 0
    inteiro fim_nivel_2 = 0

    funcao inicio()
    {
        mostrar_introducao()
        solicitar_percentuais()
        inicializar_cenario()
        calcular_niveis()
        mostrar_cenario()
        mostrar_limites_dos_niveis()
    }

    /*
     * Mostra o título e uma explicação inicial.
     */
    funcao mostrar_introducao()
    {
        escreva("========================================\n")
        escreva("          JOGO CACA AO TESOURO          \n")
        escreva("========================================\n")
        escreva("O tabuleiro possui 25 casas (5 x 5).\n\n")
    }

    /*
     * Solicita os percentuais dos três níveis.
     *
     * Os valores serão solicitados novamente enquanto:
     * - existir algum percentual negativo;
     * - a soma não for exatamente 100%;
     * - não sobrarem pelo menos duas casas fora do Nível I.
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
                escreva("A soma dos percentuais deve ser exatamente 100%.\n")
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
     *
     * A biblioteca Tipos converte o resultado real para inteiro.
     */
    funcao inteiro arredondar_casas(real valor)
    {
        retorne tipos.real_para_inteiro(valor + 0.5)
    }

    /*
     * Preenche todas as casas da matriz com "---".
     */
    funcao inicializar_cenario()
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
     * Calcula automaticamente os limites dos níveis.
     *
     * O fim do Nível II é calculado usando a soma
     * dos percentuais dos níveis I e II.
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

        /*
         * O vetor utiliza índices de 0 até 24.
         *
         * Exemplo com 25%, 35% e 40%:
         * índices 0 até 5   = Nível I
         * índices 6 até 14  = Nível II
         * índices 15 até 24 = Nível III
         */
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
     * Mostra a matriz 5 x 5.
     */
    funcao mostrar_cenario()
    {
        inteiro linha
        inteiro coluna

        escreva("TABULEIRO INICIAL\n\n")

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
     * Exibe o início e o fim de cada nível.
     */
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
}