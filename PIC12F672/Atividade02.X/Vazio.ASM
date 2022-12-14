;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
;*              MODIFICA??ES PARA USO COM 12F675                   *
;*                FEITAS PELO PROF. MARDSON                        *
;*                      MAR?O DE 2021                              *
;*                 BASEADO NO EXEMPLO DO LIVRO                     *
;*           Desbravando o PIC. David Jos? de Souza                *
;*-----------------------------------------------------------------*
;*   MODELO PARA O PIC 12F675                                      *
;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *

;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
;*                     ARQUIVOS DE DEFINI??ES                      *
;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
#INCLUDE <p12f675.inc>	;ARQUIVO PADR?O MICROCHIP PARA 12F675

	__CONFIG _BODEN_OFF & _CP_OFF & _PWRTE_ON & _WDT_OFF & _MCLRE_ON & _INTRC_OSC_NOCLKOUT

;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
;*                    PAGINA??O DE MEM?RIA                         *
;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
;DEFINI??O DE COMANDOS DE USU?RIO PARA ALTERA??O DA P?GINA DE MEM?RIA
#DEFINE	BANK0	BCF STATUS,RP0	;SETA BANK 0 DE MEM?RIA
#DEFINE	BANK1	BSF STATUS,RP0	;SETA BANK 1 DE MAM?RIA

;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
;*                         VARI?VEIS                               *
;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
; DEFINI??O DOS NOMES E ENDERE?OS DE TODAS AS VARI?VEIS UTILIZADAS 
; PELO SISTEMA

	CBLOCK	0x20	;ENDERE?O INICIAL DA MEM?RIA DE
					;USU?RIO
		W_TEMP		;REGISTRADORES TEMPOR?RIOS PARA USO
		STATUS_TEMP	;JUNTO ?S INTERRUP??ES

		;COLOQUE AQUI SUAS NOVAS VARI?VEIS
		;N?O ESQUE?A COMENT?RIOS ESCLARECEDORES
		
		;VARIAVEIS DE ENTRADA
		X1 ;0x22 LOCAL DA MEMORIA ONDE A VARIAVEL ESTA LOCARIZADA
		Y1 ;0x23 LOCAL DA MEMORIA ONDE A VARIAVEL ESTA LOCARIZADA
		Z1 ;0x24 LOCAL DA MEMORIA ONDE A VARIAVEL ESTA LOCARIZADA

	ENDC			;FIM DO BLOCO DE DEFINI??O DE VARI?VEIS

;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
;*                        FLAGS INTERNOS                           *
;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
; DEFINI??O DE TODOS OS FLAGS UTILIZADOS PELO SISTEMA

;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
;*                         CONSTANTES                              *
;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
; DEFINI??O DE TODAS AS CONSTANTES UTILIZADAS PELO SISTEMA

;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
;*                           ENTRADAS                              *
;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
; DEFINI??O DE TODOS OS PINOS QUE SER?O UTILIZADOS COMO ENTRADA
; RECOMENDAMOS TAMB?M COMENTAR O SIGNIFICADO DE SEUS ESTADOS (0 E 1)

;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
;*                           SA?DAS                                *
;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
; DEFINI??O DE TODOS OS PINOS QUE SER?O UTILIZADOS COMO SA?DA
; RECOMENDAMOS TAMB?M COMENTAR O SIGNIFICADO DE SEUS ESTADOS (0 E 1)

;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
;*                       VETOR DE RESET                            *
;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *

	ORG	0x00			;ENDERE?O INICIAL DE PROCESSAMENTO
	GOTO	INICIO
	
;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
;*                    IN?CIO DA INTERRUP??O                        *
;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
; ENDERE?O DE DESVIO DAS INTERRUP??ES. A PRIMEIRA TAREFA ? SALVAR OS
; VALORES DE "W" E "STATUS" PARA RECUPERA??O FUTURA

	ORG	0x04			;ENDERE?O INICIAL DA INTERRUP??O
	MOVWF	W_TEMP		;COPIA W PARA W_TEMP
	SWAPF	STATUS,W
	MOVWF	STATUS_TEMP	;COPIA STATUS PARA STATUS_TEMP

;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
;*                    ROTINA DE INTERRUP??O                        *
;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
; AQUI SER?O ESCRITAS AS ROTINAS DE RECONHECIMENTO E TRATAMENTO DAS
; INTERRUP??ES

;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
;*                 ROTINA DE SA?DA DA INTERRUP??O                  *
;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
; OS VALORES DE "W" E "STATUS" DEVEM SER RECUPERADOS ANTES DE 
; RETORNAR DA INTERRUP??O

SAI_INT
	SWAPF	STATUS_TEMP,W
	MOVWF	STATUS		;MOVE STATUS_TEMP PARA STATUS
	SWAPF	W_TEMP,F
	SWAPF	W_TEMP,W	;MOVE W_TEMP PARA W
	RETFIE

;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
;*	            	 ROTINAS E SUBROTINAS                      *
;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
; CADA ROTINA OU SUBROTINA DEVE POSSUIR A DESCRI??O DE FUNCIONAMENTO
; E UM NOME COERENTE ?S SUAS FUN??ES.

SUBROTINA1

	;CORPO DA ROTINA

	RETURN

;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
;*                     INICIO DO PROGRAMA                          *
;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
	
INICIO
	BANK1				;ALTERA PARA O BANCO 1
	MOVLW	B'00000000' ;CONFIGURA TODAS AS PORTAS DO GPIO (PINOS)
	MOVWF	TRISIO		;COMO SA?DAS
	CLRF	ANSEL 		;DEFINE PORTAS COMO Digital I/O
	MOVLW	B'00000100'
	MOVWF	OPTION_REG	;DEFINE OP??ES DE OPERA??O
	MOVLW	B'00000000'
	MOVWF	INTCON		;DEFINE OP??ES DE INTERRUP??ES
	BANK0				;RETORNA PARA O BANCO
	MOVLW	B'00000111'
	MOVWF	CMCON		;DEFINE O MODO DE OPERA??O DO COMPARADOR ANAL?GICO

;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
;*                     INICIALIZA??O DAS VARI?VEIS                 *
;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
	;SETANDO VALORES PARA AS VARIAVEIS DE ENTRADA
	;IREMOS INICIALIZAR ESSAS VARIAVEIS E ATRIBUIR OS VALORES A SEREM USADOS NO PROGRAMA
	;POIS N?O TEMOS UMA FORMA DE LER ENTRADA ATUALMENTE
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
	
	;------- ESSA PARTE VERIFICA SE O TAMANHO DOS LADOS S?O COMPAT?VEIS ENTRE SI -------------
	;ESSA REGI?O SUBSTITUI A PARTE ONDE VERIFICA DE X1,Y1 E Z1 S?O IGUAIS A ZERO, J? QUE SERIA REDUNDANTE UTILIZAR ISSO AQUI
	;E ESSA REGI?O FAZ A VERIFICA??O DE FORMA CORRETA, DIFERENTE DA ATIVIDADE 1
	
	;O PRIMEIRO BLOCO DE OPERACAO VERIFICA SE X1+Y1 E MAIOR QUE Z1
	MOVFW X1 ;MOVE X1 PARA WORK
	ADDWF Y1,W ;REALIZA A SOMA DE Y1 COM X1, SALVANDO O RESULTADO EM W
	SUBWF Z1,W ;SUBTRAI Z1 DA SOMA DE Y1 COM X1, SALVA O RESULTANTE EM W
	BTFSC STATUS,C ;PULA SE A SUBTRA??O ACIMA DER MENOR QUE 0
	GOTO NAO_EXISTE_TRIANGULO
	
	;O SEGUNDO BLOCO DE OPERACAO VERIFICA SE X1+Z1 E MAIOR QUE Y1
	MOVFW X1 ;MOVE X1 PARA WORK
	ADDWF Z1,W ;REALIZA A SOMA DE Z1 COM X1, SALVANDO O RESULTADO EM W
	SUBWF Y1,W ;SUBTRAI Y1 DA SOMA DE Z1 COM X1, SALVA O RESULTANTE EM W
	BTFSC STATUS,C ;PULA SE A SUBTRA??O ACIMA DER MENOR QUE 0
	GOTO NAO_EXISTE_TRIANGULO
	
	;O TERCEIRO BLOCO DE OPERACAO VERIFICA SE Y1+Z1 E MAIOR QUE X1
	MOVFW Y1 ;MOVE Y1 PARA WORK
	ADDWF Z1,W ;REALIZA A SOMA DE Z1 COM Y1, SALVANDO O RESULTADO EM W
	SUBWF X1,W ;SUBTRAI X1 DA SOMA DE Z1 COM Y1, SALVA O RESULTANTE EM W
	BTFSC STATUS,C ;PULA SE A SUBTRA??O ACIMA DER MENOR QUE 0
	GOTO NAO_EXISTE_TRIANGULO
	
;------ AGORA O SISTEMA IRA VERIFICAR QUAL TIPO DE TRIANGULO ?, J? QUE FOI CONCLUIDO QUE E REALMENTE UM TRIANGULO ----------------------
	;IRA VERIFICAR SE X1 E Y1 SAO IGUAIS
	MOVFW X1 ;MOVE X1 PARA WORK
	SUBWF Y1,W ;REALIZA A SUBTRACAO DE Y1 POR X1, SALVA O RESULTANTE EM W
	BTFSS STATUS,Z ;VERIFICA SE A SUBTRACAO OCORRIDA NA LINHA ACIMA DEU IGUAL A ZERO - PULA SE IGUAL A ZERO
	GOTO X1_DIF_Y1
	
	;IR? VERIFICAR SE O TRIANGULO ? EQUILATERO VENDO SE X1 = Z1, JA QUE X1 = Y1
	MOVFW X1 ;MOVE X1 PARA WORK
	SUBWF Z1,W ;REALIZA A SUBTRACAO DE Z1 POR X1, SALVA O RESULTANTE EM W
	BTFSS STATUS,Z ;VERIFICA SE A SUBTRACAO OCORRIDA NA LINHA ACIMA DEU IGUAL A ZERO - PULA SE IGUAL A ZERO
	GOTO ISOCELES
	GOTO EQUILATERO
	
X1_DIF_Y1 ;ESSE TRECHO VERIFICA SE O TRIANGULO ? ISOCELES OU ESCALENO J? QUE ELE N?O PODE SER EQUILATERO, X1 DIFERENTE DE Y1
	;IR? VERIFICAR SE O TRIANGULO ? ISOCELES VENDO SE X1 = Z1
	MOVFW X1 ;MOVE Y1 PARA WORK
	SUBWF Z1,W ;REALIZA A SUBTRACAO DE Z1 POR Y1, SALVA O RESULTANTE EM W
	BTFSC STATUS,Z ;VERIFICA SE A SUBTRACAO OCORRIDA NA LINHA ACIMA DEU IGUAL A ZERO - PULA SE DIFERENTE DE ZERO
	GOTO ISOCELES
	
	;IR? VERIFICAR SE O TRIANGULO ? ISOCELES OU ESCALENO VENDO SE Y1 = Z1
	MOVFW Y1 ;MOVE Y1 PARA WORK
	SUBWF Z1,W ;REALIZA A SUBTRACAO DE Z1 POR Y1, SALVA O RESULTANTE EM W
	BTFSS STATUS,Z ;VERIFICA SE A SUBTRACAO OCORRIDA NA LINHA ACIMA DEU IGUAL A ZERO - PULA SE IGUAL A ZERO
	GOTO ESCALENO
	GOTO ISOCELES

;---------- ESSE TRECHO IR? SETAR NO REGISTRADOR W O VALOR CORRESPONDENTE AO TIPO DE TRIANGULO ----------
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
	;1 - ESCALENO - TODOS OS LADOS S?O DIFERENTES
	;2 - ISOCELES - DOIS LADOS S?O IGUAIS
	;3 - EQUIL?TERO - TODOS OS LADOS S?O IGUAIS
	;4 - OS LADOS N?O FORMAM UM TRIANGULO
	GOTO FINAL

;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
;*                       FIM DO PROGRAMA                           *
;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *

	END
