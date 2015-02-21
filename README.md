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
* Copy the "include" and "common" directories from this template to a local location. 
* Edit the Makefile: 
 * Set TOOLPATH in the Makefile to the Teensy directory where the arm-none-eabi binaries live.
 * Set TEENSY3X_BASEPATH to the location of the "include" and "common" directories.
   Alternately:
   Keep the directories in the pwd and set the TEENSH3X_BASEPATH to the present working directory

##Example Commands:##
* Compile: $make all
* Compile and Upload: $make load
