programa
{
    // Matriz que representa o tabuleiro 5 x 5.
    cadeia cenario[5][5]

    // Quantidade fixa de linhas e colunas.
    const inteiro LINHAS = 5
    const inteiro COLUNAS = 5

    funcao inicio()
    {
        escreva("========================================\n")
        escreva("          JOGO CACA AO TESOURO          \n")
        escreva("========================================\n\n")

        inicializar_cenario()
        mostrar_cenario()
    }

    /*
     * Preenche todas as 25 posições da matriz
     * com o código de casa vazia: ---
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
     * Percorre a matriz e mostra o tabuleiro
     * organizado em 5 linhas e 5 colunas.
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

        escreva("\nTotal: 25 casas.\n")
    }
}