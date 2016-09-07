# processing-projection-graffiti
Paint software on steroids built for light projection graffiti.
Inspired by http://johnnylee.net/projects/wii/ and http://www.instructables.com/id/PROJECTION-BOMBING/?ALLSTEPS

Prerequisites
------
* Download [Processing 2.0](https://processing.org/tutorials/gettingstarted/) and above and Install.
* Install required libraries: Go to 'Sketch' --> 'Import Library' --> 'Add Library'.
  1. `Spout for Processing`
  2. `ControlP5`
  3. `oscP5`
* Download & install [smoothboard](http://www.smoothboard.net/). This is only necessary if you want to do projection graffiti. 
* You would also need at least one Wiimote, an [IR pen/spraycan](http://johnnylee.net/projects/wii/pen.jpg), and a projector connected to a power source for projection graffiti.

Getting Started
-----
1. Clone this repository.
2. Open any `.pde` file with `Processing` app.
3. Run the code and make your own graffiti!


Equipment Setup Steps For Projection Graffiti
------
1. Boot Laptop.
2. Put tripods without wiimotes in position. See [this](http://www.smoothboard.net/files/graphics/info/Wiimote_Whiteboard_Setup.jpg) for an idea on good positions to place the wiimotes.
3. Launch Smoothboard application.
4. Press the `1` and `2` buttons on wiimotes to turn their bluetooths on.
5. Once Smoothboard application has connected to wiimotes and launched,  mount wiimotes on tripods. Note which wiimote is the primary wiimote and place this one on the primary tripod. The primary wiimote can be identified by looking at the 4 lights at the bottom of the wiimote. The primary wiimote will have the first light lit.
6. Press `A` button on wiimotes to calibrate.
7. When calibration is complete, open `paint_with_palette.pde` with Processing and Run.


Default Keyboard Configuration
------
* RESET: SPACEBAR
* SAVE SCREEN: `s`
* LOAD IMAGE: `l`. You can change the image file to load by changing the `loadingFileName` string in `paint_with_palette.pde`
* UNDO: `LEFT` arrow key
* REDO: `RIGHT` arrow key

------

Additional Settings Configuration
------
* Number of wiimotes to use: In Smoothboard application, click 'Settings' --> 'General' --> 'Wiimotes'. Select new number of wiimotes to use and restart application
* Number of strokes before saving the screen as an image to `data/timestamps`: In `paint_with_palette.pde`, amend `NUM_STROKES_AUTO_SAVE` variable.
* Cursor shown/not shown: In `paint_with_palette.pde`, go to `setup()` function, find `cursor(CROSS)` or `noCursor()`. Comment/uncomment the necessary line.
* Position of tool panel: In `paint_with_palette.pde`, find `toolPanelPosition` and change that to `top`, `bottom`, `left`, or `right`.
