# TPI-EDII
Trabajo Final Integrador de la materia Electrónica Digital II. 

## ALCANCE DEL TRABAJO
El trabajo se centra en armar un sistema embebido con el microcontrolador PIC 16F887. 
Para este se debera hacer uso de comunicacion UART, ADC, Interupciones, Timer, Puertos.

## IDEA DEL PROYECTO
Se implementara un sistema de control de acceso para barrios cerrados. Este sistema tendra los siguientes requerimientos funcionales:
- Debe contar con un lector de tarjetas de acceso.
- Para poder entrar al barrio se debere apoyar la terjeta en el lector e introducir una clave de 4 digitos a traves de un teclado.
- La clave se visualizara en 4 displays 7 segmentos.
- Si la iluminacion del ambiente es baja, se encendera una luz para iluminar al conductor.
- En estado de reposo, en los displays mostraran "0000", ningun led estara encendido, la barrera estara abajo, y no se tendra en cuenta la iluminacion ambiente.
- Cuando se apoye una tarjeta, se tendra en cuenta la iluminacion ambiente, los displays mostraran "----", a medida que se introducen los caracteres de la clave se iran mostrando en los displays.
- Si la clave coincide con el id correspondiente a la tarjeta, se levantara la barrera (por un determinado tiempo), se dara la notificacion de ingreso a una computadora y se encendera un led verde.
- La barrera se simulara con un servo motor el cual controlaremos por PWM.
- Si la clave no coincide con el id correspondiente a la tarjeta, se encendera un led rojo, se dara la notificacion de error a una computadora. El led permanecera rojo un determinado tiempo.
- Una vez terminado el tiempo de demora, el sistema volvera al estado de reposo esperando una nueva tarjeta.

De esta forma abarcamos todos los requerimientos del TFI. Se utilizara la comunicacion UART para la comunicacion con la PC y con el modulo RFID (Modulo para las tarjetas de acceso). Para la iluminacion del ambiente se usara el sensor OPT101, el cual tiene una salida analogica por lo que usaremos el ADC.

## SUBSISTEMAS Y SUS COMPONENTES
- SSE.1.1 Señalizacion Optica: Cuenta con un Led Rojo y un Led Verde.
- SSE.1.2 Entrada de Datos: Cuenta con 9 botones dispuestos como un teclado matricial de 3x3.
- SSE.1.3 Visualizavion de Datos: Cuenta con 4 Display's CC, con sus correspondientes transistores para el control de cada uno.
- SSE.1.4 Barrera de Acceso: Cuenta con un servomotor, el driver correspondiente y un optoacoplador(IC PC817) para aislar la etapa de potencia de la de control.
- SSE.1.5 Reflector: Cuenta con una lampara y un rele para su activacion.
- SSE.1.6 Lector de Tarjetas: Utilizaremos el modulo RDM6300 el cual podremos utilizar con comunicacion UART.
- SSE.2.1 PIC16F887: Contara del PIC, el circuito minimo para su funcionamiento (cristal, capacitores, etc) y el circuito nesesario para la programacion mediante el PICKIT3.
- SSE.2.2 OPT101: En este subsistema utilizaremos el sensor OPT101, como tambien un circuito para obtener el valor de referencia nesesario.
- SSE.2.3 Conversor Serial to USB: Utilizaremos un modulo comercial al cual le adaptaremos el conector USB para poder usar un USB Tipo B Hembra.

#PROGRAMACION
Para la programacion del PIC 16F887 se usara ASEMBLER.

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
