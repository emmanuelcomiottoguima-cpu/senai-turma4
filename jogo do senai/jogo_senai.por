programa
{
    inclua biblioteca Util --> util
    inclua biblioteca Tipos --> tipos

    // -------------------- CONSTANTES --------------------

    const inteiro LINHAS = 5
    const inteiro COLUNAS = 5
    const inteiro TOTAL_CASAS = 25

    // -------------------- MATRIZ E VETOR --------------------

    cadeia cenario[5][5]
    inteiro nivel_das_casas[25]

    // -------------------- PERCENTUAIS --------------------

    real percentual_nivel_1 = 0.0
    real percentual_nivel_2 = 0.0
    real percentual_nivel_3 = 0.0

    // Última casa pertencente aos níveis I e II.
    inteiro fim_nivel_1 = 0
    inteiro fim_nivel_2 = 0

    // Posições sorteadas, usando índices entre 0 e 24.
    inteiro casa_b05 = -1
    inteiro casa_b10 = -1
    inteiro casa_risco = -1
    inteiro casa_tesouro = -1

    funcao inicio()
    {
        mostrar_introducao()
        solicitar_percentuais()
        GerarCenario()
        mostrar_cenario()
        mostrar_limites_dos_niveis()
        mostrar_posicoes_sorteadas()
    }

    funcao mostrar_introducao()
    {
        escreva("========================================\n")
        escreva("          JOGO CACA AO TESOURO          \n")
        escreva("========================================\n")
        escreva("O tabuleiro possui 25 casas (5 x 5).\n\n")
    }

    /*
     * Solicita e valida os percentuais.
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
     * Responsável por:
     * 1. inicializar a matriz;
     * 2. calcular os limites dos níveis;
     * 3. atribuir um nível para cada casa;
     * 4. sortear os elementos;
     * 5. impedir sobreposição.
     */
    funcao GerarCenario()
    {
        inicializar_matriz()
        calcular_niveis()
        sortear_elementos()
    }

    /*
     * Preenche todas as 25 casas com "---".
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
     * Calcula os limites acumulados dos níveis
     * e registra o nível de cada casa.
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
     * Sorteia e posiciona os quatro elementos.
     *
     * Os bônus podem ficar em qualquer nível.
     * O risco e o tesouro começam depois do Nível I.
     */
    funcao sortear_elementos()
    {
        // Bônus de 5 créditos: qualquer uma das 25 casas.
        casa_b05 = sortear_casa_livre(0, TOTAL_CASAS - 1)
        colocar_conteudo(casa_b05, "B05")

        // Bônus de 10 créditos: qualquer casa ainda livre.
        casa_b10 = sortear_casa_livre(0, TOTAL_CASAS - 1)
        colocar_conteudo(casa_b10, "B10")

        /*
         * O primeiro índice disponível depois do Nível I
         * é exatamente o valor armazenado em fim_nivel_1.
         *
         * Exemplo:
         * Se o Nível I possui 6 casas, ele usa os índices
         * 0 até 5. O sorteio começa no índice 6.
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
     * Sorteia uma casa dentro do intervalo recebido.
     *
     * Se a posição já estiver ocupada, o sorteio
     * será repetido até encontrar uma casa vazia.
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
     * Recebe um índice entre 0 e 24 e coloca
     * o conteúdo na linha e coluna correspondentes.
     */
    funcao colocar_conteudo(inteiro casa, cadeia conteudo)
    {
        inteiro linha
        inteiro coluna

        linha = casa / COLUNAS
        coluna = casa % COLUNAS

        cenario[linha][coluna] = conteudo
    }

    /*
     * Retorna o conteúdo de uma casa.
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
     * Mostra o cenário completo.
     *
     * Nesta etapa ele é mostrado imediatamente
     * para facilitar o teste dos sorteios.
     */
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

    /*
     * Mostra os limites calculados.
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

    /*
     * Mostra as posições para conferir se os elementos
     * foram realmente colocados sem sobreposição.
     *
     * É somado 1 porque os índices internos vão de
     * 0 a 24, mas as casas são apresentadas de 1 a 25.
     */
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