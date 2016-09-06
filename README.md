# processing-projection-graffiti
Paint software on steroids built for light projection graffiti.
Inspired by http://johnnylee.net/projects/wii/

Prerequisites
------
* Download [Processing 2.0](https://processing.org/tutorials/gettingstarted/) and above and Install.
* Install required libraries: Go to 'Sketch' --> 'Import Library' --> 'Add Library'.
  1. `Spout for Processing`
  2. `ControlP5`
  3. `oscP5`


Getting started
-----
1. Clone this repository.
2. Open any `.pde` file with `Processing` app.
3. Run the code and make your own graffiti!


Projection Tracking Prerequisites
------
1. Donwload & install [smoothboard](http://www.smoothboard.net/)

Projection Tracking: Get Started
------
1. Boot Laptop
2. Put tripods without wiimotes in position
3. Launch Smoothboard application
4. Press the `1` and `2` buttons on wiimotes to turn their bluetooths on
5. Once Smoothboard application has connected to wiimotes and launched,  mount wiimotes on tripods. Note which wiimote is the primary wiimote and place this one on the primary tripod. The primary wiimote can be identified by looking at the 4 lights at the bottom of the wiimote. The primary wiimote will have the first light lit.
6. Press `A` button on wiimotes to calibrate.
7. When calibration is complete, open `paint_with_palette.pde` with Processing and Run

------

SETTINGS CONFIGURATION:
--> Number of wiimotes to use: In Smoothboard application, click 'Settings' --> 'General' --> 'Wiimotes'. Select new number of wiimotes to use and restart application

--> Cursor shown/not shown: In `paint_with_palette.pde` go to `setup()` function, find `cursor(CROSS)` or `noCursor()`. Comment/uncomment the necessary line.
