import netP5.*;
import oscP5.*;
import spout.*;
import controlP5.*;
import java.util.*;
import java.lang.Math;

//window width and heights for easy changes
final int W = 1280;
final int H = 800;
final boolean spoutOn = false;

// Spout objects
Spout spoutOut;
Spout spoutIn;
Spout spoutTopIn;

// OSC objects
OscP5 oscP5;
NetAddress myRemoteLocation;  

// PGraphics objects for layers
PGraphics paintLayer;
PGraphics spoutInLayer;
PGraphics spoutInTopLayer;

// Panel attributes
private static color currentColor;
private String currentBrushType;
private int currentBrushRadius;
private ToolPanel toolPanel;
private BrushFactory brushFactory;
private ControlP5 cp5;

private float TOOL_PANEL_WIDTH;

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
private int[][] strokeStartEndCoords = new int[2][2];

void setup()
{
  //fullScreen(P3D);
  size(1280, 800, P3D); //change accordingly to W and H above
  textureMode(NORMAL);

  background(0);
  frameRate(60);
  cursor(CROSS);
  currentColor = color(255);
  cp5 = new ControlP5(this);
  TOOL_PANEL_WIDTH = width * 0.07;
  toolPanel = new ToolPanel(0, 0, TOOL_PANEL_WIDTH, height, color(0), cp5);
  brushFactory = new BrushFactory();
  totalStrokeCount = 0;

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
  
  paintLayer.beginDraw();
  paintLayer.clear();
  
  // initialize undo/redo array of images
  for (int i = 0; i < imageCarousel.length; i++)
  {
    imageCarousel[i] = paintLayer.get();
  }
  
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
  if (mousePressed && mouseX>TOOL_PANEL_WIDTH && toolPanel.isPanelMinimized()) 
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
      brushFactory.rollerEraser(200, currentColor);
      break;
    }
    

    //OSC implementation here
    OscMessage myMessageX = new OscMessage("/ClickX");
    myMessageX.add(mouseX); 
    OscMessage myMessageY = new OscMessage("/ClickY");
    myMessageY.add(mouseY); 

    float redValue = red(currentColor);
    float greenValue = green(currentColor);
    float blueValue = blue(currentColor);
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
  if (key == ' ') // clear and reset screen
  {
    resetScreen();
  }
  else if (key == 'l') // load screen
  {
    String fileName = "1471332245368.png";
    loadScreen(fileName);
  }
  else if (key == 's') // save screen
  {
    saveScreen();
  }
  else if (key == CODED) // redo and undo
  {
    if (keyCode == LEFT && undoSteps > 0)
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
    else if (keyCode == RIGHT && redoSteps > 0)
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

void mouseReleased()
{  
  ++totalStrokeCount;
  if (totalStrokeCount % 20 == 0)
  {
    saveScreen();
  }
  
  if (mouseX > TOOL_PANEL_WIDTH)
  {
    int[] temp = {mouseX, mouseY};
    strokeStartEndCoords[1] = temp;
    switch (currentBrushType)
    {
      case "bolt":
        brushFactory.drawBoltShape(currentColor, strokeStartEndCoords[0], strokeStartEndCoords[1]);
        break;
      case "lightbolt":
        brushFactory.drawLightBoltShape(currentColor, strokeStartEndCoords[0], strokeStartEndCoords[1]);
        break;
    }
    // save current screen after a stroke is drawn
    undoSteps = min(undoSteps+1, NUM_UNDO_ALLOWED);
    redoSteps = 0;
    currentImagesIndex = (currentImagesIndex + 1) % imageCarousel.length;
    imageCarousel[currentImagesIndex] = spoutOn? paintLayer.get() : get();
    println(undoSteps, redoSteps, currentImagesIndex);
  }
}

void mouseClicked()
{
  if (mouseX > TOOL_PANEL_WIDTH)
  {
    toolPanel.minimizeAll();
    addUsedColorToMemory();
  }
}

void mousePressed()
{
  if (mouseX < TOOL_PANEL_WIDTH && toolPanel.isPanelMinimized())
  {
    toolPanel.maximizePanel();
  } 
  else if (mouseX > TOOL_PANEL_WIDTH)
  {
    toolPanel.minimizeAll();
    addUsedColorToMemory();
    if (currentBrushType == "bolt" || currentBrushType == "lightbolt")
    {
      int[] temp = {mouseX, mouseY};
      strokeStartEndCoords[0] = temp;
    }
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
  Calendar cal = Calendar.getInstance();
  long timestamp = cal.getTimeInMillis();
  save(timestamp+".png");
}

private void addUsedColorToMemory()
{
  if (!savedColors.contains(currentColor))
  {
    savedColors.add(currentColor);
  }
  if (mouseButton == RIGHT) //right click to select spout source
  {
    // Bring up a dialog to select a sender.
    if (spoutOn)
    {
      spoutOut.selectSender();
    }
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