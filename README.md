# TPI-EDII
Trabajo Final Integrador de la materia Electrónica Digital II. 

## ALCANCE DEL TRABAJO
El trabajo se centra en armar un sistema embebido con el microcontrolador PIC 16F887. 
Para este se debera hacer uso de comunicacion UART, ADC, Interupciones, Timer, Puertos.

## IDEA DEL PROYECTO
Se implementara un sistema de control de acceso para barrios cerrados. Este sistema tendra los siguientes requerimientos funcionales:
- Debe contar con un lector de tarjetas de acceso.
- Para poder entrar al barrio se debera apoyar la terjeta en el lector e introducir una clave de 4 digitos a traves de un teclado.
- La clave se visualizara en 4 displays 7 segmentos CC.
- Si la iluminacion del ambiente es baja, se encendera una lampara led de 12v para iluminar al conductor.
- En estado de reposo, en los displays mostraran "0000", ningun led estara encendido, la barrera estara abajo, y no se tendra en cuenta la iluminacion ambiente.
- Cuando se apoye una tarjeta, se tendra en cuenta la iluminacion ambiente, los displays mostraran "----", a medida que se introducen los caracteres de la clave se iran mostrando en los displays.
- Si la clave coincide con el id correspondiente a la tarjeta, se levantara la barrera (por un determinado tiempo), se dara la notificacion de ingreso a una computadora y se encendera un led verde.
- La barrera consta de un servomotor con su correspondiente driver el cual controlaremos con una señal PWM.
- Para los circuitos de la etapa de potencia, como lo son la lampara led y el servomotor, utilizaremos optoacopladores para tener un aislamiento galvanico entre los circuitos.
- Si la clave no coincide con el id correspondiente a la tarjeta, se encendera un led rojo, se dara la notificacion de error a una computadora. El led permanecera rojo un determinado tiempo.
- Una vez terminado el tiempo de demora, el sistema volvera al estado de reposo esperando una nueva tarjeta.
- Resumiendo, se enviara a la computadora los siguientes datos:
    - ID de la tarjeta ingresada
    - Acceso Denegado / Acceso Concedido
    - Iluminancia del ambiente

De esta forma abarcamos todos los requerimientos del TFI. Se utilizara la comunicacion UART para la comunicacion con la PC y con el modulo RFID (Modulo para las tarjetas de acceso). Para la iluminacion del ambiente se usara el sensor OPT101, el cual tiene una salida analogica por lo que usaremos el ADC.

## PROGRAMACION
El PIC16F887 se programara en ASEMBLY, debido a los criterios de la materia.

## COMPONENTES UTILIZADOS
- PIC 16F887
- Modulo RFID: RDM6300
- Sensor luminico: OPT101
- 1 Led Rojo
- 1 Led Verde
- 1 Led de alta luminicidad Blanco
- 4 Displays CC
- 10 Botones
- Modulo TTL-USB
- Pin hembra USB tipo B
- Transistores BJT ...
- Resistencias ...
- Regulador de voltaje 7805
- Borneras ...
- Pines macho arduino ...
- Servo motor ...
- ...
(Las hojas de datos, asi como paginas con informacion sobre el uso de los componenetes estaran en la carpeta de /documentacion/investigacion)

## SIMULACION
Antes de armar la PCB se hizo una simulacion de todo el sistema en PROTEUS. La simulacion se puede encontrar dentro de este repo en la carpeta simulacion. Ademas, se utilizo la herramienta PROTEUS para el diseño de la PCB.

## PCB FINAL
(FOTO DE LA PCB ENTREGADA)
