######################################################
#Template Project for Teensy 3.1 Barechip Development#
######################################################
http://elegantcircuits.com/2015/02/03/bare-metal-programming-the-teensy-3-1-arm-development-board-without-the-arduino-ide/

##Requirements:##
* Arduino IDE (Versions 1.0.5 or 1.0.6 only)
* Teensyduino plugin: https://www.pjrc.com/teensy/teensyduino.html
* Teensy 3.1 development board

##Installation:##
* Install the Arduino IDE and the Teensyduino Plugin. 
* Copy the "<TT>teensy_basepath</TT>" directory from this template to a local "teensy_basepath" location. 
* Edit the Makefile: 
 * Set <TT>TOOLPATH</TT> to the arduino <TT>arm-none-eabi</TT> directory.
 * Set <TT>TEENSYDIR</TT> to the arduino <TT>hardware</TT> directory.
 * Set <TT>TEENSY3X_BASEPATH</TT> to the location of the local "<TT>teensy_basepath</TT>" Directory.   
       Alternately:    
       Keep the directories in the <TT>pwd</TT> and set the <TT>TEENSY3X_BASEPATH</TT> to the present working directory

##Example Commands:##
* Compile: <TT>$make all</TT>
* Compile and load: <TT>$make load</TT>
