######################################################
#Template Project for Teensy 3.1 Barechip Development#
######################################################
http://elegantcircuits.com/2015/02/03/bare-metal-programming-the-teensy-3-1-arm-development-board-without-the-arduino-ide/

Requirements:
* Arduino IDE (Versions 1.0.5 or 1.0.6 only)
* Teensyduino plugin (https://www.pjrc.com/teensy/teensyduino.html)
* Teensy 3.1 development board

1. Install the Arduino IDE and the Teensyduino Plugin
   Point the TOOLPATH in the Makefile to the directory Teensy directory where the arm-none-eabi binaries live

2. Copy the "include" and "common" directories to a local location
   Point to this location in the Makefile as TEENSY3X_BASEPATH
   Alternately:
   Keep the directories in the pwd and set the TEENSH3X_BASEPATH to the present working directory

Example Commands:
* Compile: $make all
* Compile and Upload: $make load
