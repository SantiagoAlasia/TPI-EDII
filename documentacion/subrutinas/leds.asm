; configuracion del estado inicial de los leds de señalizacion optica
	    MOVLW   .1
	    MOVWF   LED_STATUS

; RESTO DEL PROGRAMA

; subrutina para el maneja los leds del subsistema de señalizacion optica
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
