;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
;*              MODIFICAÇÕES PARA USO COM 12F675                   *
;*                FEITAS PELO PROF. MARDSON                        *
;*                      MARÇO DE 2021                              *
;*                 BASEADO NO EXEMPLO DO LIVRO                     *
;*           Desbravando o PIC. David José de Souza                *
;*-----------------------------------------------------------------*
;*   MODELO PARA O PIC 12F675                                      *
;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *

;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
;*                     ARQUIVOS DE DEFINIÇÕES                      *
;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
#INCLUDE <p12f675.inc>	;ARQUIVO PADRÃO MICROCHIP PARA 12F675

	__CONFIG _BODEN_OFF & _CP_OFF & _PWRTE_ON & _WDT_OFF & _MCLRE_ON & _INTRC_OSC_NOCLKOUT

;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
;*                    PAGINAÇÃO DE MEMÓRIA                         *
;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
;DEFINIÇÃO DE COMANDOS DE USUÁRIO PARA ALTERAÇÃO DA PÁGINA DE MEMÓRIA
#DEFINE	BANK0	BCF STATUS,RP0	;SETA BANK 0 DE MEMÓRIA
#DEFINE	BANK1	BSF STATUS,RP0	;SETA BANK 1 DE MAMÓRIA

;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
;*                         VARIÁVEIS                               *
;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
; DEFINIÇÃO DOS NOMES E ENDEREÇOS DE TODAS AS VARIÁVEIS UTILIZADAS 
; PELO SISTEMA

	CBLOCK	0x20	;ENDEREÇO INICIAL DA MEMÓRIA DE
					;USUÁRIO
		W_TEMP		;REGISTRADORES TEMPORÁRIOS PARA USO
		STATUS_TEMP	;JUNTO ÀS INTERRUPÇÕES

		;COLOQUE AQUI SUAS NOVAS VARIÁVEIS
		;NÃO ESQUEÇA COMENTÁRIOS ESCLARECEDORES
		
		;VARIAVEIS DE ENTRADA
		X1 ;0x22 LOCAL DA MEMORIA ONDE A VARIAVEL ESTA LOCARIZADA
		Y1 ;0x23 LOCAL DA MEMORIA ONDE A VARIAVEL ESTA LOCARIZADA
		Z1 ;0x24 LOCAL DA MEMORIA ONDE A VARIAVEL ESTA LOCARIZADA

	ENDC			;FIM DO BLOCO DE DEFINIÇÃO DE VARIÁVEIS

;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
;*                        FLAGS INTERNOS                           *
;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
; DEFINIÇÃO DE TODOS OS FLAGS UTILIZADOS PELO SISTEMA

;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
;*                         CONSTANTES                              *
;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
; DEFINIÇÃO DE TODAS AS CONSTANTES UTILIZADAS PELO SISTEMA

;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
;*                           ENTRADAS                              *
;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
; DEFINIÇÃO DE TODOS OS PINOS QUE SERÃO UTILIZADOS COMO ENTRADA
; RECOMENDAMOS TAMBÉM COMENTAR O SIGNIFICADO DE SEUS ESTADOS (0 E 1)

;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
;*                           SAÍDAS                                *
;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
; DEFINIÇÃO DE TODOS OS PINOS QUE SERÃO UTILIZADOS COMO SAÍDA
; RECOMENDAMOS TAMBÉM COMENTAR O SIGNIFICADO DE SEUS ESTADOS (0 E 1)

;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
;*                       VETOR DE RESET                            *
;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *

	ORG	0x00			;ENDEREÇO INICIAL DE PROCESSAMENTO
	GOTO	INICIO
	
;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
;*                    INÍCIO DA INTERRUPÇÃO                        *
;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
; ENDEREÇO DE DESVIO DAS INTERRUPÇÕES. A PRIMEIRA TAREFA É SALVAR OS
; VALORES DE "W" E "STATUS" PARA RECUPERAÇÃO FUTURA

	ORG	0x04			;ENDEREÇO INICIAL DA INTERRUPÇÃO
	MOVWF	W_TEMP		;COPIA W PARA W_TEMP
	SWAPF	STATUS,W
	MOVWF	STATUS_TEMP	;COPIA STATUS PARA STATUS_TEMP

;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
;*                    ROTINA DE INTERRUPÇÃO                        *
;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
; AQUI SERÃO ESCRITAS AS ROTINAS DE RECONHECIMENTO E TRATAMENTO DAS
; INTERRUPÇÕES

;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
;*                 ROTINA DE SAÍDA DA INTERRUPÇÃO                  *
;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
; OS VALORES DE "W" E "STATUS" DEVEM SER RECUPERADOS ANTES DE 
; RETORNAR DA INTERRUPÇÃO

SAI_INT
	SWAPF	STATUS_TEMP,W
	MOVWF	STATUS		;MOVE STATUS_TEMP PARA STATUS
	SWAPF	W_TEMP,F
	SWAPF	W_TEMP,W	;MOVE W_TEMP PARA W
	RETFIE

;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
;*	            	 ROTINAS E SUBROTINAS                      *
;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
; CADA ROTINA OU SUBROTINA DEVE POSSUIR A DESCRIÇÃO DE FUNCIONAMENTO
; E UM NOME COERENTE ÀS SUAS FUNÇÕES.

SUBROTINA1

	;CORPO DA ROTINA

	RETURN

;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
;*                     INICIO DO PROGRAMA                          *
;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
	
INICIO
	BANK1				;ALTERA PARA O BANCO 1
	MOVLW	B'00000000' ;CONFIGURA TODAS AS PORTAS DO GPIO (PINOS)
	MOVWF	TRISIO		;COMO SAÍDAS
	CLRF	ANSEL 		;DEFINE PORTAS COMO Digital I/O
	MOVLW	B'00000100'
	MOVWF	OPTION_REG	;DEFINE OPÇÕES DE OPERAÇÃO
	MOVLW	B'00000000'
	MOVWF	INTCON		;DEFINE OPÇÕES DE INTERRUPÇÕES
	BANK0				;RETORNA PARA O BANCO
	MOVLW	B'00000111'
	MOVWF	CMCON		;DEFINE O MODO DE OPERAÇÃO DO COMPARADOR ANALÓGICO

;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
;*                     INICIALIZAÇÃO DAS VARIÁVEIS                 *
;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
	;SETANDO VALORES PARA AS VARIAVEIS DE ENTRADA
	;IREMOS INICIALIZAR ESSAS VARIAVEIS E ATRIBUIR OS VALORES A SEREM USADOS NO PROGRAMA
	;POIS NÃO TEMOS UMA FORMA DE LER ENTRADA ATUALMENTE
	MOVLW .0 ;SETA O VALOR DECIMAL PARA WORK
	MOVWF X1 ;SETA O VALOR DE WORK PARA X1
	
	MOVLW .0 ;SETA O VALOR DECIMAL PARA WORK
	MOVWF Y1 ;SETA O VALOR DE WORK PARA Y1
	
	MOVLW .0 ;SETA O VALOR DECIMAL PARA WORK
	MOVWF Z1 ;SETA O VALOR DE WORK PARA Z1
;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
;*                     ROTINA PRINCIPAL                            *
;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
MAIN

	;CORPO DA ROTINA PRINCIPAL
	
;---------------------- FAZ O TESTE SE ESSES TRES LADOS FORMAM UM TRIANGULO ---------------------------
	
	;------- ESSA PARTE VERIFICA SE O TAMANHO DOS LADOS SÃO COMPATÍVEIS ENTRE SI -------------
	;ESSA REGIÃO SUBSTITUI A PARTE ONDE VERIFICA DE X1,Y1 E Z1 SÃO IGUAIS A ZERO, JÁ QUE SERIA REDUNDANTE UTILIZAR ISSO AQUI
	;E ESSA REGIÃO FAZ A VERIFICAÇÃO DE FORMA CORRETA, DIFERENTE DA ATIVIDADE 1
	
	;O PRIMEIRO BLOCO DE OPERACAO VERIFICA SE X1+Y1 E MAIOR QUE Z1
	MOVFW X1 ;MOVE X1 PARA WORK
	ADDWF Y1,W ;REALIZA A SOMA DE Y1 COM X1, SALVANDO O RESULTADO EM W
	SUBWF Z1,W ;SUBTRAI Z1 DA SOMA DE Y1 COM X1, SALVA O RESULTANTE EM W
	BTFSC STATUS,C ;PULA SE A SUBTRAÇÃO ACIMA DER MENOR QUE 0
	GOTO NAO_EXISTE_TRIANGULO
	
	;O SEGUNDO BLOCO DE OPERACAO VERIFICA SE X1+Z1 E MAIOR QUE Y1
	MOVFW X1 ;MOVE X1 PARA WORK
	ADDWF Z1,W ;REALIZA A SOMA DE Z1 COM X1, SALVANDO O RESULTADO EM W
	SUBWF Y1,W ;SUBTRAI Y1 DA SOMA DE Z1 COM X1, SALVA O RESULTANTE EM W
	BTFSC STATUS,C ;PULA SE A SUBTRAÇÃO ACIMA DER MENOR QUE 0
	GOTO NAO_EXISTE_TRIANGULO
	
	;O TERCEIRO BLOCO DE OPERACAO VERIFICA SE Y1+Z1 E MAIOR QUE X1
	MOVFW Y1 ;MOVE Y1 PARA WORK
	ADDWF Z1,W ;REALIZA A SOMA DE Z1 COM Y1, SALVANDO O RESULTADO EM W
	SUBWF X1,W ;SUBTRAI X1 DA SOMA DE Z1 COM Y1, SALVA O RESULTANTE EM W
	BTFSC STATUS,C ;PULA SE A SUBTRAÇÃO ACIMA DER MENOR QUE 0
	GOTO NAO_EXISTE_TRIANGULO
	
;------ AGORA O SISTEMA IRA VERIFICAR QUAL TIPO DE TRIANGULO É, JÁ QUE FOI CONCLUIDO QUE E REALMENTE UM TRIANGULO ----------------------
	;IRA VERIFICAR SE X1 E Y1 SAO IGUAIS
	MOVFW X1 ;MOVE X1 PARA WORK
	SUBWF Y1,W ;REALIZA A SUBTRACAO DE Y1 POR X1, SALVA O RESULTANTE EM W
	BTFSS STATUS,Z ;VERIFICA SE A SUBTRACAO OCORRIDA NA LINHA ACIMA DEU IGUAL A ZERO - PULA SE IGUAL A ZERO
	GOTO X1_DIF_Y1
	
	;IRÁ VERIFICAR SE O TRIANGULO É EQUILATERO VENDO SE X1 = Z1, JA QUE X1 = Y1
	MOVFW X1 ;MOVE X1 PARA WORK
	SUBWF Z1,W ;REALIZA A SUBTRACAO DE Z1 POR X1, SALVA O RESULTANTE EM W
	BTFSS STATUS,Z ;VERIFICA SE A SUBTRACAO OCORRIDA NA LINHA ACIMA DEU IGUAL A ZERO - PULA SE IGUAL A ZERO
	GOTO ISOCELES
	GOTO EQUILATERO
	
X1_DIF_Y1 ;ESSE TRECHO VERIFICA SE O TRIANGULO É ISOCELES OU ESCALENO JÁ QUE ELE NÃO PODE SER EQUILATERO, X1 DIFERENTE DE Y1
	;IRÁ VERIFICAR SE O TRIANGULO É ISOCELES VENDO SE X1 = Z1
	MOVFW X1 ;MOVE Y1 PARA WORK
	SUBWF Z1,W ;REALIZA A SUBTRACAO DE Z1 POR Y1, SALVA O RESULTANTE EM W
	BTFSC STATUS,Z ;VERIFICA SE A SUBTRACAO OCORRIDA NA LINHA ACIMA DEU IGUAL A ZERO - PULA SE DIFERENTE DE ZERO
	GOTO ISOCELES
	
	;IRÁ VERIFICAR SE O TRIANGULO É ISOCELES OU ESCALENO VENDO SE Y1 = Z1
	MOVFW Y1 ;MOVE Y1 PARA WORK
	SUBWF Z1,W ;REALIZA A SUBTRACAO DE Z1 POR Y1, SALVA O RESULTANTE EM W
	BTFSS STATUS,Z ;VERIFICA SE A SUBTRACAO OCORRIDA NA LINHA ACIMA DEU IGUAL A ZERO - PULA SE IGUAL A ZERO
	GOTO ESCALENO
	GOTO ISOCELES

;---------- ESSE TRECHO IRÁ SETAR NO REGISTRADOR W O VALOR CORRESPONDENTE AO TIPO DE TRIANGULO ----------
ESCALENO ;SETA O VALOR DE W PARA 1 - ESCALENO
	MOVLW .1
	GOTO FINAL

ISOCELES ;SETA O VALOR DE W PARA 2 - ESCALENO
	MOVLW .2
	GOTO FINAL
	
EQUILATERO ;SETA O VALOR DE W PARA 3 - EQUILATERO
	MOVLW .3
	GOTO FINAL
	
NAO_EXISTE_TRIANGULO
	;SETA RESPOSTA COMO 4 INFORMANDO QUE NAO EXISTE TRIANGULO
	MOVLW .4
	GOTO FINAL
	
FINAL
	;SAIDAS DE W
	;1 - ESCALENO - TODOS OS LADOS SÃO DIFERENTES
	;2 - ISOCELES - DOIS LADOS SÃO IGUAIS
	;3 - EQUILÁTERO - TODOS OS LADOS SÃO IGUAIS
	;4 - OS LADOS NÃO FORMAM UM TRIANGULO
	GOTO FINAL

;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
;*                       FIM DO PROGRAMA                           *
;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *

	END
