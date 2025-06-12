; subrutina para el manejo de la lampara	   
LAMPARA	    
	    BANKSEL PORTD
	    BTFSS   PORTD, RD7
	    GOTO    LAMP_ON
	    GOTO    LAMP_OFF
LAMP_ON
	    BSF	    PORTD, RD7
	    GOTO    CONT_LAMP
LAMP_OFF
	    BCF	    PORTD, RD7
	    GOTO    CONT_LAMP
CONT_LAMP
	    RETURN
