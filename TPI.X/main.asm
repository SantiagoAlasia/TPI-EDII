LIST P=16F887
#include "p16f887.inc"

__CONFIG _CONFIG1, _XT_OSC & _WDTE_OFF & _MCLRE_ON & _LVP_OFF

; definicion de variables
CBLOCK  0X20
	; variables para el salvado de contexto
	W_TEMP
	STATUS_TEMP

	; variables para el manejo de displays y teclado
	NTecla
	CONT_NTecla
	
	NDisplay1
	NDisplay2
	NDisplay3
	NDisplay4
	
	DELAY_1
	DELAY_2
	DELAY_3
	
	; variable para la señalizacion optica 
	LED_STATUS
	
	; variable del valor de referencia
	REFH
	REFL
ENDC
	
	    ORG	    0X00
	    GOTO    INICIO
	    ORG	    0X04
	    GOTO    ISR_INICIO
	    ORG	    0X05
	  
; configuracion de los puertos
CONF_PORT   MACRO
	    ; configuracion de los pines digitales y analogicos
	    BANKSEL ANSEL
	    MOVLW   0X03
	    MOVWF   ANSEL
	    BANKSEL ANSELH
	    CLRF    ANSELH
	    
	    ; configuracion de los distintos puertos
	    BANKSEL TRISA
	    MOVLW   0X03
	    MOVWF   TRISA   ;se define RA0 y RA1 como entradas analogicas
	    MOVLW   0X07
	    MOVWF   TRISB
	    MOVWF   WPUB
	    MOVWF   IOCB
	    CLRF    TRISC
	    CLRF    TRISD
	    
	    BANKSEL PORTB
	    CLRF    PORTB
	    CLRF    PORTC
	    CLRF    PORTD
	    
ENDM
 
; configuracion de las interupciones principales
CONF_INT    MACRO
	    BANKSEL OPTION_REG
	    MOVLW   0X00
	    MOVWF   OPTION_REG
	    MOVLW   0X88
	    MOVWF   INTCON
ENDM
    
; configuracion del ADC
CONF_ADC    MACRO
	    BANKSEL	ADCON0
	    MOVLW	0X44
	    MOVWF	ADCON0
	    
	    BANKSEL	ADCON1
	    MOVLW	0X80
	    MOVWF	ADCON1
	    
	    	
ENDM   

; configuracion de la trasmicion y recepcion serie
;CONF_UART   MACRO
;ENDM
    
; incio del programa con la configuraciones nesesarias
INICIO	    
	    ; seteo de los valores de los displays a 0
	    MOVLW   .0
	    MOVWF   NDisplay1
	    MOVWF   NDisplay2
	    MOVWF   NDisplay3
	    MOVWF   NDisplay4
	    
	    ; numero del display actual 
	    MOVLW   .4
	    MOVWF   CONT_NTecla
	    
	    ; configuracion del estado inicial de los leds de señalizacion optica
	    MOVLW   .0
	    MOVWF   LED_STATUS
	    
	    ; configuracion del micro
	    CONF_PORT
	    CONF_INT
	    CONF_ADC
	    ;CONF_UART

	    ; guardamos el valor de referencia para el sensor de iluminisencia
	    BSF	    ADCON0, GO
POOLING	    BTFSC   ADCON0, GO
	    GOTO    POOLING
	    BANKSEL ADCON0
	    MOVLW   0X41
	    MOVWF   ADCON0
	    
	    BANKSEL ADRESH
	    MOVF    ADRESH, W
	    BANKSEL REFH
	    MOVWF   REFH
	    BANKSEL ADRESL
	    MOVF    ADRESL, W
	    BANKSEL REFL
	    MOVWF   REFL
	    
; loop principal para la visualizacion de los displays
LOOP	    CALL    ACT_DSPL
	    CALL    LEDS
	    GOTO    LOOP

; subrutina de interupcion	  
ISR_INICIO  
	    MOVWF   W_TEMP
	    SWAPF   STATUS,W
	    MOVWF   STATUS_TEMP
	    
	    BTFSC   INTCON, RBIF
	    GOTO    ISR_RBI ; subrutina para los teclados
	    GOTO    ISR_FIN ; subrutina para la restauracion de contexto
	    
; subrutina para el manejo del teclado
ISR_RBI
	    CALL    TECLA_PRESS
	    CALL    TECLA_LOAD
	    BCF	    INTCON, RBIF
	    GOTO    ISR_FIN
	    
TECLA_PRESS	    
	    CLRF    NTecla
	    INCF    NTecla, F
	    MOVLW   B'00110000' ; Fila 1 baja
	    MOVWF   PORTB
	    NOP
    
	    BTFSS   PORTB, 0
	    GOTO    TECL_DELAY
	    INCF    NTecla, F
	    BTFSS   PORTB, 1
	    GOTO    TECL_DELAY
	    INCF    NTecla, F
	    BTFSS   PORTB, 2
	    GOTO    TECL_DELAY
	    INCF    NTecla, F
	    
	    MOVLW   B'00101000' ; Fila 2 baja
	    MOVWF   PORTB
	    BTFSS   PORTB, 0
	    GOTO    TECL_DELAY
	    INCF    NTecla, F
	    BTFSS   PORTB, 1
	    GOTO    TECL_DELAY
	    INCF    NTecla, F
	    BTFSS   PORTB, 2
	    GOTO    TECL_DELAY
	    INCF    NTecla, F
		
	    MOVLW   B'00011000' ; Fila 3 baja
	    MOVWF   PORTB
	    BTFSS   PORTB, 0
	    GOTO    TECL_DELAY
	    INCF    NTecla, F
	    BTFSS   PORTB, 1
	    GOTO    TECL_DELAY
	    INCF    NTecla, F
	    BTFSS   PORTB, 2
	    GOTO    TECL_DELAY
	    INCF    NTecla, F
    
	    CLRF    NTecla
	    RETURN
    
TECL_DELAY
Espera1	    BTFSS   PORTB, 0
	    GOTO    Espera1
Espera2	    BTFSS   PORTB, 1
	    GOTO    Espera2
Espera3	    BTFSS   PORTB, 2
	    GOTO    Espera3

	    RETURN
	 
TECLA_LOAD  
	    MOVLW   .4	
	    SUBWF   CONT_NTecla, W
	    BTFSC   STATUS, Z
	    CALL    LOAD_TECLA4
	    MOVLW   .3
	    SUBWF   CONT_NTecla, W
	    BTFSC   STATUS, Z
	    CALL    LOAD_TECLA3
	    MOVLW   .2	
	    SUBWF   CONT_NTecla, W
	    BTFSC   STATUS, Z
	    CALL    LOAD_TECLA2
	    MOVLW   .1
	    SUBWF   CONT_NTecla, W
	    BTFSC   STATUS, Z
	    CALL    LOAD_TECLA1
	    
	    DECFSZ  CONT_NTecla, F
	    RETURN
	    MOVLW   .4
	    MOVWF   CONT_NTecla
	    RETURN
	    
LOAD_TECLA1 
	    MOVF    NTecla, W
	    MOVWF   NDisplay1
	    RETURN

LOAD_TECLA2 
	    MOVF    NTecla, W
	    MOVWF   NDisplay2
	    RETURN
	    
LOAD_TECLA3 
	    MOVF    NTecla, W
	    MOVWF   NDisplay3
	    RETURN
	  
LOAD_TECLA4 
	    MOVF    NTecla, W
	    MOVWF   NDisplay4
	    RETURN
	    
; restauracion de contexto y vuelta de la subrutina
ISR_FIN	    
	    SWAPF   STATUS_TEMP,W
	    MOVWF   STATUS
	    SWAPF   W_TEMP,F
	    SWAPF   W_TEMP,W
	    RETFIE
	
; maneja los leds del subsistema de señalizacion optica
LEDS	    
	    BANKSEL LED_STATUS
	    MOVF    LED_STATUS, W
	    SUBLW   .1
	    BTFSS   STATUS, C
	    GOTO    ROJO_ON	; si LED_STATUS = 2, significa que debemos prender el led rojo
	    BTFSS   STATUS, Z
	    GOTO    TODO_OFF	; si LED_STATUS = 0, significa que debemos apagar los dos leds
	    GOTO    VERDE_ON	; si LED_STATUS = 1, significa que debemos prender el led verde
	    
ROJO_ON	    BSF	    PORTB, RB6
	    BCF	    PORTB, RB7
	    GOTO    CONTINUAR

VERDE_ON    BCF	    PORTB, RB6
	    BSF	    PORTB, RB7
	    GOTO    CONTINUAR
	    
TODO_OFF    BCF	    PORTB, RB6
	    BCF	    PORTB, RB7
	  
CONTINUAR   RETURN
	 
; muestra de los registros NDisplayi por los display
ACT_DSPL    
	    BANKSEL PORTD
	    MOVF    NDisplay1, W
	    CALL    NUMERO
	    MOVWF   PORTD
	    BSF	    PORTC, RC2
	    CALL    DELAY
	    BCF	    PORTC, RC2
	    
	    MOVF    NDisplay2, W
	    CALL    NUMERO
	    MOVWF   PORTD
	    BSF	    PORTC, RC3
	    CALL    DELAY
	    BCF	    PORTC, RC3
	    
	    MOVF    NDisplay3, W
	    CALL    NUMERO
	    MOVWF   PORTD
	    BSF	    PORTC, RC4
	    CALL    DELAY
	    BCF	    PORTC, RC4
	    
	    MOVF    NDisplay4, W
	    CALL    NUMERO
	    MOVWF   PORTD
	    BSF	    PORTC, RC5
	    CALL    DELAY
	    BCF	    PORTC, RC5
	    
	    RETURN
	    
; subrutina para un delay de 7ms
DELAY	    
	    MOVLW   .255
	    MOVWF   DELAY_1
LOOP_1	    MOVLW   .1
	    MOVWF   DELAY_2
LOOP_2	    MOVLW   .3
	    MOVWF   DELAY_3
LOOP_3	    DECFSZ  DELAY_3,F
	    GOTO    LOOP_3
	    DECFSZ  DELAY_2,F
	    GOTO    LOOP_2
	    DECFSZ  DELAY_1,F
	    GOTO    LOOP_1
	    RETURN
	    
; tabla para la conversion del numero en los seg 
NUMERO	    
	    ADDWF	PCL,F
	    RETLW	0X3F
	    RETLW	0X06
	    RETLW	0X5B
	    RETLW	0X4F
	    RETLW	0X66
	    RETLW	0X6D
	    RETLW	0X7D
	    RETLW	0X07
	    RETLW	0X7F
	    RETLW	0X67
	    RETLW	0X40
	 
END