;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
;*              MODIFICA??ES PARA USO COM 12F675                   *
;*                FEITAS PELO PROF. MARDSON                        *
;*                    FEVEREIRO DE 2016                            *
;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *

;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
;*                       NOME DO PROJETO                           *
;*                           CLIENTE                               *
;*         DESENVOLVIDO PELA MOSAICO ENGENHARIA E CONSULTORIA      *
;*   VERS?O: 1.0                           DATA: 17/06/03          *
;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
;*                     DESCRI??O DO ARQUIVO                        *
;*-----------------------------------------------------------------*
;*   MODELO PARA O PIC 12F675                                      *
;*                                                                 *
;*                                                                 *
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
		;NOVAS VARI?VEIS

	ENDC			;FIM DO BLOCO DE MEM?RIA
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

	
;0.00381679389S ? IGUAL A 3,82MS PARA O PERIODO DE TEMPO DE 262HZ
; -> 0.00190839694 TEMPO PARA O DELAY EM SEGUNDOS NESSA FREQUENCIA
DELAY_0 ;262HZ, CALCULANDO QUAL O TEMPO PARA DAR ESSA FREQUENCIA, ENCONTRAMOS O VALOR DE 3,816MS
	;CALCULAR O DIFERENCIAL DE 255 COM O QUE QUEREMOS PARA CHEGAR AO VALOR DESEJADO
	MOVLW	.137	;O TIMER PARA 3,82MS COME?A EM 18 E VAI ATE 255, MAS PARA METADE DESSE TEMPO COMPREENDENDO A SUBIDA E DECIDA DO SINAL PARA FORMAR O PERIODO, O VALOR VAI DE 137 PARA 255
	MOVWF	TMR0	;COLOCA O VALOR 137 NO TIMER0 PARA COME?AR A CONTAR
	BCF	INTCON,T0IF ;SETA A FLAG DO TIMER0 PARA 0
ESPERA
	BTFSS	INTCON,T0IF ;FAZ A VERIFICA??O SE A FLAG DO TIMER0 EST? EM 1, SE SIM SAI DO DELAY_0
	GOTO	ESPERA
	RETURN

	
;0.00227272727S ? IGUAL A 2,27MS PARA O PERIODO DE TEMPO DE 440HZ
; -> 0.00113636363 TEMPO PARA O DELAY EM MS NESSA FREQUENCIA
DELAY_1 ;440HZ, CALCULANDO QUAL O TEMPO PARA DAR ESSA FREQUENCIA, ENCONTRAMOS O VALOR DE 2,27MS DO PERIODO, ENTAO O TEMPO SERIA PARA INVERTER O VALOR DA VARIAVEL
	;CALCULAR O DIFERENCIAL DE 255 COM O QUE QUEREMOS PARA CHEGAR AO VALOR DESEJADO
	MOVLW	.186	;O TIMER PARA 2,27MS COME?A EM 115 E VAI ATE 255, MAS PARA METADE DESSE TEMPO COMPREENDENDO A SUBIDA E DECIDA DO SINAL PARA FORMAR O PERIODO, O VALOR VAI DE 186 AT? 255
	MOVWF	TMR0	;COLOCA O VALOR 137 NO TIMER0 PARA COME?AR A CONTAR
	BCF	INTCON,T0IF ;SETA A FLAG DO TIMER0 PARA 0
ESPERA_1
	BTFSS	INTCON,T0IF ;FAZ A VERIFICA??O SE A FLAG DO TIMER0 EST? EM 1, SE SIM SAI DO DELAY_1
	GOTO	ESPERA_1
	RETURN

;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
;*                     INICIO DO PROGRAMA                          *
;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
	
INICIO
	BANK1				;ALTERA PARA O BANCO 1
	MOVLW	B'00001000' ;CONFIGURA TODAS AS PORTAS DO GPIO (PINOS)
	MOVWF	TRISIO		;COMO SA?DAS
	CLRF	ANSEL 		;DEFINE PORTAS COMO Digital I/O
	MOVLW	B'00000011' ;O PRESCALER RATE EST? CONFIGURADO PARA 1:16
	MOVWF	OPTION_REG	;DEFINE OP??ES DE OPERA??O
	MOVLW	B'00000000'
	MOVWF	INTCON		;DEFINE OP??ES DE INTERRUP??ES
	CALL	0X03FF
	MOVWF	OSCCAL
	BANK0				;RETORNA PARA O BANCO
	MOVLW	B'00000111'
	MOVWF	CMCON		;DEFINE O MODO DE OPERA??O DO COMPARADOR ANAL?GICO

;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
;*                     INICIALIZA??O DAS VARI?VEIS                 *
;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
	CLRF	GPIO
	
	;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
;*                     ROTINA PRINCIPAL                            *
;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
MAIN
	;FAZ A VERIFICA??O DA ENTRADA GP3, SE 1, SETA A FREQUENCIA DA SAIDA DO GP5 EM 440HZ
	BTFSC	GPIO,GP3
	GOTO	SIGNAL_440HZ
	
	;REGIAO ONDE A SAIDA DO GP5 SAI EM 262HZ
	BSF	GPIO,GP5    ;SETA A SAIDA DO GP5 EM 1
	CALL	DELAY_0	    ;FAZ UMA ESPERA DE 1,908MS
	BCF	GPIO,GP5    ;SETA A SAIDA DO GP5 EM 0
	CALL	DELAY_0	    ;FAZ UMA ESPERA DE 1,908MS
	GOTO	MAIN	    ;VOLTA PARA A LABEL MAIN
	
SIGNAL_440HZ	;REGIAO ONDE A SAIDA DO GP5 SAI EM 440HZ
	BSF	GPIO,GP5    ;SETA A SAIDA DO GP5 EM 1  
	CALL	DELAY_1	    ;FAZ UMA ESPERA DE 1,363MS
	BCF	GPIO,GP5    ;SETA A SAIDA DO GP5 EM 0
	CALL	DELAY_1	    ;FAZ UMA ESPERA DE 1,363MS
	GOTO	MAIN	    ;VOLTA PARA A LABEL MAIN
	
;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
;*                       FIM DO PROGRAMA                           *
;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *

	END
