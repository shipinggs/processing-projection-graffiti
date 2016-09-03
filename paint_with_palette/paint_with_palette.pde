import netP5.*;
import oscP5.*;
import spout.*;
import controlP5.*;
import java.util.*;
import java.lang.Math;

//window width and heights for easy changes
final int W = 1920;
final int H = 1200;
final boolean spoutOn = false;

// Keyboard configuration
private char RESET_KEY = ' ';
private char SAVE_KEY = 's';
private char LOAD_KEY = 'l';
private char UNDO_KEY = LEFT;
private char REDO_KEY = RIGHT;

// Panel attributes
// Set panel position here - left, right, top, or bottom
private String toolPanelPosition = "left";
private color toolPanelColor = color(0);
private static color currentColor;
private String currentBrushType;
private int currentBrushRadius;
private ToolPanel toolPanel;
private BrushFactory brushFactory;
private ControlP5 cp5;

// for generating timestamp when saving screen. see saveScreen()
private Calendar cal;

// to store drips created
private static ArrayList<Drip> drips = new ArrayList<Drip>();

// to store last 5 colours used
private static ArrayList<Integer> savedColors = new ArrayList<Integer>();

// to store snapshots and implement undo redo logic
private int NUM_UNDO_ALLOWED = 20;
private PImage[] imageCarousel = new PImage[NUM_UNDO_ALLOWED+1];
private int currentImagesIndex = 0, undoSteps = 0, redoSteps = 0;
private int totalStrokeCount;

// to store coordinates of mouse press and release
int[] pressCoords = new int[2], releaseCoords = new int[2];

// Spout objects
Spout spoutOut;
Spout spoutIn;
Spout spoutTopIn;

// OSC objects
OscP5 oscP5;
NetAddress myRemoteLocation;
float redValue, greenValue, blueValue;

// PGraphics objects for layers
PGraphics paintLayer;
PGraphics spoutInLayer;
PGraphics spoutInTopLayer;

void setup()
{
  fullScreen(P3D);
  //size(1280, 800, P3D); //change accordingly to W and H above
  textureMode(NORMAL);

  background(0);
  frameRate(60);
  cursor(CROSS);
  currentColor = color(255);
  cp5 = new ControlP5(this);
  
  //// spout objects
  if (spoutOn)
  {
    spoutOut = new Spout(this);
    spoutIn = new Spout(this);
    spoutTopIn = new Spout(this);
    spoutIn.createReceiver("Resolume Bottom - Resolume Arena"); // name of bottom layer in resolume: brandon
    spoutTopIn.createReceiver("Resolume Top - Resolume Arena"); // name of top layer in resolume: brandon
  }

  // OSC object
  oscP5 = new OscP5(this, 7000);
  myRemoteLocation = new NetAddress("localhost", 12001);

  //the two layers
  paintLayer = createGraphics(W, H, P2D);
  spoutInLayer = createGraphics(W, H, PConstants.P2D);
  spoutInTopLayer = createGraphics(W, H, PConstants.P2D);
  
  toolPanel = new ToolPanel(toolPanelPosition, toolPanelColor, cp5);
  brushFactory = new BrushFactory();
  totalStrokeCount = 0;
  
  paintLayer.beginDraw();
  paintLayer.clear();
  
  // initialize undo/redo array of images
  for (int i = 0; i < imageCarousel.length; i++)
  {
    imageCarousel[i] = paintLayer.get();
  }
  
  resetScreen();
}

void draw()
{
  if (spoutOn)
  {
    spoutInLayer = spoutIn.receiveTexture(spoutInLayer); //puts the spout input onto the layer
    spoutInTopLayer = spoutTopIn.receiveTexture(spoutInTopLayer); //puts the spout input onto the layer
  }

  currentColor = color(toolPanel.getColor());
  currentBrushType = toolPanel.getBrushType();
  currentBrushRadius = toolPanel.getBrushRadius();

  paintLayer.beginDraw();  //draw on that particular layer only

  // Now if the mouse is pressed, paint
  if (mousePressed && !toolPanel.withinPanelArea() && toolPanel.isPanelMinimized()) 
  {
    switch (currentBrushType)
    {
    case "solid":
      brushFactory.solidBrush(currentBrushRadius, currentColor);
      break;
    case "feathered":
      brushFactory.featheredBrush(currentBrushRadius, currentColor);
      break;
    case "gritty":
      brushFactory.grittyBrush(currentBrushRadius, currentColor);
      break;
    case "drip":
      brushFactory.dripBrush(currentBrushRadius, currentColor);
      break;
    case "eraser":
      brushFactory.rollerEraser(currentBrushRadius, currentColor);
      break;
    }
    

    //OSC implementation here
    OscMessage myMessageX = new OscMessage("/ClickX");
    myMessageX.add(mouseX); 
    OscMessage myMessageY = new OscMessage("/ClickY");
    myMessageY.add(mouseY); 

    redValue = red(currentColor);
    greenValue = green(currentColor);
    blueValue = blue(currentColor);
    OscMessage myMessageRed = new OscMessage("/Red");
    myMessageRed.add(redValue); 
    OscMessage myMessageGreen = new OscMessage("/Green");
    myMessageRed.add(greenValue); 
    OscMessage myMessageBlue = new OscMessage("/Blue");
    myMessageRed.add(blueValue); 
    oscP5.send(myMessageX, myRemoteLocation); 
    oscP5.send(myMessageY, myRemoteLocation); 
    oscP5.send(myMessageRed, myRemoteLocation); 
    oscP5.send(myMessageGreen, myRemoteLocation); 
    oscP5.send(myMessageBlue, myRemoteLocation); 
    //end of OSC implementation
  }

  // animate drips dropping if there are any
  for (Drip drip : drips)
  {
    drip.render();
  }

  toolPanel.render();
  paintLayer.endDraw();  //end of things to draw on the particular layer

  //layer arrangement
  if (spoutOn)
  {
    image(spoutInLayer, 0, 0); //bottom: bottom spout layer
  }
  image(paintLayer, 0, 0); //middle: original drawings
  if (spoutOn)
  {
    image(spoutInTopLayer, 0, 0); //top: top spout layer
    spoutOut.sendTexture(paintLayer); //send the paint out via spout
  }
} //end of draw


void keyPressed()
{
  if (key == RESET_KEY) // clear and reset screen
  {
    resetScreen();
  }
  else if (key == LOAD_KEY) // load screen
  {
    String fileName = "timestamps/.png";
    loadScreen(fileName);
  }
  else if (key == SAVE_KEY) // save screen
  {
    saveScreen();
  }
  else if (key == CODED)
  {
    if (keyCode == UNDO_KEY && undoSteps > 0) // undo
    {
      --undoSteps;
      ++redoSteps;
      currentImagesIndex  = (currentImagesIndex - 1 + imageCarousel.length) % imageCarousel.length;
      clear();
      paintLayer.beginDraw();
      paintLayer.tint(255, 255);
      paintLayer.clear();
      paintLayer.image(imageCarousel[currentImagesIndex], 0, 0);
      paintLayer.endDraw();
    } 
    else if (keyCode == REDO_KEY && redoSteps > 0) //redo
    {
      ++undoSteps;
      --redoSteps;
      currentImagesIndex = (currentImagesIndex + 1) % imageCarousel.length;
      paintLayer.beginDraw();
      paintLayer.clear();
      paintLayer.image(imageCarousel[currentImagesIndex], 0, 0);
      paintLayer.endDraw();
    }
  }
}

void mousePressed()
{
  pressCoords[0] = mouseX;
  pressCoords[1] = mouseY;
  
  if (!toolPanel.withinPanelArea())
  {
    toolPanel.minimizeAll();
    addUsedColorToMemory();
  }
}

void mouseReleased()
{  
  if (totalStrokeCount > 0 && totalStrokeCount%20 == 0)
  {
    saveScreen();
  }
  if (toolPanel.withinPanelArea())
  {
    toolPanel.maximizePanel();
  }
  else
  {
    ++totalStrokeCount;
    // save coordinates of mouse release
    releaseCoords[0] = mouseX;
    releaseCoords[1] = mouseY;
    
    // if current brush type is a stencil
    if (brushFactory.stencilsList.contains(currentBrushType))
    {
      brushFactory.drawStencil(currentBrushType, currentColor, pressCoords, releaseCoords);
    }
   
    // save current screen after a stroke is drawn
    undoSteps = min(undoSteps+1, NUM_UNDO_ALLOWED);
    redoSteps = 0;
    currentImagesIndex = (currentImagesIndex + 1) % imageCarousel.length;
    imageCarousel[currentImagesIndex] = spoutOn? paintLayer.get() : get();
    println(undoSteps, redoSteps, currentImagesIndex);
  }
}

private void resetScreen()
{
  clear();
  paintLayer.beginDraw();
  paintLayer.clear();
  paintLayer.endDraw();
  if (spoutOn) spoutInLayer.clear();

  savedColors.clear();
  drips.clear();
  resetImageCarousel();
  toolPanel.minimizeAll();
  totalStrokeCount = 0;  
}

private void loadScreen(String fileName)
{
  PImage img;
  img = loadImage(fileName);
  paintLayer.beginDraw();
  paintLayer.clear();
  paintLayer.image(img, 0, 0);
  paintLayer.endDraw();
}

private void saveScreen()
{
  cal = Calendar.getInstance();
  long timestamp = cal.getTimeInMillis();
  save("timestamps/" +timestamp+".png");
}

private void addUsedColorToMemory()
{
  if (!savedColors.contains(currentColor))
  {
    savedColors.add(currentColor);
  }
}

private void resetImageCarousel()
{
  println("RESET");
  for (int i = 0; i < imageCarousel.length; i++)
  {
    imageCarousel[i] = paintLayer.get();
  }
  currentImagesIndex = 0;
  undoSteps = 0;
  redoSteps = 0;
}

public static void addDrip(Drip drip)
{
  drips.add(drip);
}