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

private float TOOL_PANEL_WIDTH;

private static color currentColor;
private String currentBrushType;
private int currentBrushRadius;
private ToolPanel toolPanel;
private BrushFactory brushFactory;
private ControlP5 cp5;

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

// to store drips created
private static ArrayList<Drip> drips = new ArrayList<Drip>();

// to store last 5 colours used
private static ArrayList<Integer> savedColors = new ArrayList<Integer>();

// to store last 5 undo snapshots
private int NUM_UNDO_ALLOWED = 5;
private PImage[] images = new PImage[NUM_UNDO_ALLOWED];
private int currentImagesIndex;

// to store bolt coordinates
private int[][] boltCoordinates = new int[2][2];

void setup()
{
  fullScreen(P3D);
  //size(1280, 800, P3D); //change accordingly to W and H above
  textureMode(NORMAL);
  //surface.setResizable(true);
  
  background(0);
  frameRate(60);
  cursor(CROSS);
  currentColor = color(255);
  cp5 = new ControlP5(this);
  TOOL_PANEL_WIDTH = width * 0.07;
  toolPanel = new ToolPanel(0, 0, TOOL_PANEL_WIDTH, height, color(0), cp5);
  brushFactory = new BrushFactory();
  
  //// spout objects
  if(spoutOn){
  spoutOut = new Spout(this);
  spoutIn = new Spout(this);
  spoutTopIn = new Spout(this);
  spoutIn.createReceiver("Resolume Bottom - Resolume Arena"); // name of bottom layer in resolume: brandon
  spoutTopIn.createReceiver("Resolume Top - Resolume Arena"); // name of top layer in resolume: brandon
  }
  
  // OSC object
  oscP5 = new OscP5(this,7000);
  myRemoteLocation = new NetAddress("localhost",12001);
  
  //the two layers
  paintLayer = createGraphics(W,H,P2D);
  spoutInLayer = createGraphics(W,H,PConstants.P2D);
  spoutInTopLayer = createGraphics(W,H,PConstants.P2D);
  
}

void draw()
{
  background(0); //necessary for spout to work properly, else spout frames will accumulate on screen
  
  if(spoutOn){
  spoutInLayer = spoutIn.receiveTexture(spoutInLayer); //puts the spout input onto the layer
  spoutInTopLayer = spoutTopIn.receiveTexture(spoutInTopLayer); //puts the spout input onto the layer
  }
    
  currentColor = color(toolPanel.getColor());
  currentBrushType = toolPanel.getBrushType();
  currentBrushRadius = toolPanel.getBrushRadius();
  
  paintLayer.beginDraw();  //draw on that particular layer only
  
  // Now if the mouse is pressed, paint
  if (mousePressed && mouseX>TOOL_PANEL_WIDTH && toolPanel.isPanelMinimized()) {
    paintLayer.noStroke();
    paintLayer.noFill();
    paintLayer.stroke(currentColor);
    paintLayer.strokeWeight(1);
    if (pmouseX == 0 || pmouseY == 0) {
      paintLayer.line(mouseX, mouseY, mouseX, mouseY);
    } else {
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
      //print(currentBrushType, currentBrushRadius, currentColor);
    }
    
    //OSC implementation here
    println(mouseX);
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
    println("red: " + redValue + " green: " + greenValue + " blue: " + blueValue);
    //end of OSC implementation
  }

  // animate drips dropping if there are any
  for (Drip drip: drips)
  {
    drip.render();
  }
  
  toolPanel.render();
  paintLayer.endDraw();  //end of things to draw on the particular layer
  
  //for testing of layers
  /*
  spoutInLayer.beginDraw();
  spoutInLayer.fill(#220000);
  spoutInLayer.rect(random(W),random(H),20,20);
  spoutInLayer.endDraw();
  */
  
  //layer arrangement 
  if(spoutOn){
  image(spoutInLayer,0,0); //bottom: bottom spout layer
  }
  image(paintLayer,0,0); //middle: original drawings
  if(spoutOn){
  image(spoutInTopLayer,0,0); //top: top spout layer
  }
  
  if(spoutOn){
  spoutOut.sendTexture(paintLayer); //send the paint out via spout
  }
  
  
} //end of draw


void keyPressed()
{
  if (key == ' ')
  {
    paintLayer.beginDraw();
    paintLayer.clear();
    //spoutInLayer.clear();
    paintLayer.endDraw();
    
    savedColors.clear();
    drips.clear();
    toolPanel.minimizeAll();
  }
  
  if (key == 's')
  {
    Calendar cal = Calendar.getInstance();
    long timestamp = cal.getTimeInMillis();
    save(timestamp+".jpg");
  }
}

void mouseReleased()
{  
  if (mouseX > TOOL_PANEL_WIDTH && currentBrushType == "bolt")
  {
    int[] temp = {mouseX,mouseY};
    boltCoordinates[1] = temp;
    println(Arrays.deepToString(boltCoordinates));
    brushFactory.drawBoltShape(currentColor, boltCoordinates[0], boltCoordinates[1]);
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
    if (currentBrushType == "bolt")
    {
      int[] temp = {mouseX,mouseY};
      boltCoordinates[0] = temp;
    }
  }
}

private void addUsedColorToMemory()
{
  if (!savedColors.contains(currentColor))
  {
    savedColors.add(currentColor);
  }
  if (mouseButton == RIGHT) {  //right click to select spout source
    // Bring up a dialog to select a sender.
    if(spoutOn){
    spoutOut.selectSender();
    }
  }
}

public static void addDrip(Drip drip)
{
  drips.add(drip);
}