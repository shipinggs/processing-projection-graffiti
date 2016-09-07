# processing-projection-graffiti
Paint software built for light projection graffiti.
Inspired by http://johnnylee.net/projects/wii/ and http://www.instructables.com/id/PROJECTION-BOMBING/?ALLSTEPS

Prerequisites
------
* Download [Processing 2.0](https://processing.org/tutorials/gettingstarted/) and above and Install.
* Install required libraries: Go to 'Sketch' --> 'Import Library' --> 'Add Library'.
  1. `Spout for Processing`
  2. `ControlP5`
  3. `oscP5`
* Download & install [smoothboard](http://www.smoothboard.net/). This is only necessary if you want to do projection graffiti. 
* You would also need at least one Wiimote, an [IR pen/spraycan](http://johnnylee.net/projects/wii/pen.jpg), and a projector(we recommend 5000 lumens for best effects) connected to a power source for projection graffiti.

Getting Started
-----
1. Clone this repository.
2. Open any `.pde` file with `Processing` app.
3. Run the code and make your own graffiti!


Equipment Setup Steps For Projection Graffiti
------
1. Boot Laptop.
2. Put tripods without Wiimotes in position. See [this](http://www.smoothboard.net/files/graphics/info/Wiimote_Whiteboard_Setup.jpg) for an idea on good positions to place the Wiimotes.
3. Launch Smoothboard application.
4. Press the `1` and `2` buttons on Wiimotes to turn their bluetooths on.
5. Once Smoothboard application has connected to wiimotes and launched,  mount Wiimotes on tripods. Note which Wiimote is the primary Wiimote and place this one on the primary tripod. The primary Wiimote can be identified by looking at the 4 lights at the bottom of the Wiimote. The primary Wiimote will have the first light lit.
6. Press `A` button on Wiimotes to calibrate.
7. When calibration is complete, open `paint_with_palette.pde` with Processing and Run.


Default Keyboard Configuration
------
* Reset: `SPACEBAR`
* Save: `s`
* Load: `l`. You can change the image file to load by changing the `loadingFileName` string in `paint_with_palette.pde`
* Undo: `LEFT` arrow key
* Redo: `RIGHT` arrow key

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

Additional Settings Configuration
------
* **Number of wiimotes to use**: In Smoothboard application, click 'Settings' --> 'General' --> 'Wiimotes'. Select new number of wiimotes to use and restart application

* **Number of strokes before saving the screen** as an image to `/timestamps` folder: In `paint_with_palette.pde`, amend `NUM_STROKES_AUTO_SAVE` variable.

* **Cursor shown/not shown**: In `paint_with_palette.pde`, go to `setup()` function, find `cursor(CROSS)` or `noCursor()`. Comment/uncomment the necessary line.

* **Position of tool panel**: In `paint_with_palette.pde`, find `toolPanelPosition` and change that to `top`, `bottom`, `left`, or `right`.

Power Solutions
-----
As this is a project meant for projection anywhere, there are a few solutions we have explored to provide power for the projector:

1. **Really long cable**: We prefer the [Defender](https://www.defenderpower.com/power-solutions/cable-reels/50m/defender-50m-industrial-trade-cable-reel-13a-4-way-125mm-230v-e8).

2. **On-site power generator**: In the event no power sockets are available within 50m of the projection site, you can rent a [generator](http://www.camwerkz.com/product/honda-eu20is-2000w-generator/). A 1000W generator should be sufficient for your projector.

3. **Battery and Inverter**: We have not tested this, but in theory it should work. Get a deep-cycle 12V battery with capacity of ~100Ah, and an DC to AC Inverter capable of 1000W power output.
