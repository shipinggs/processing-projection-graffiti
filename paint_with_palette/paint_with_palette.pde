import netP5.*;
import oscP5.*;

import spout.*;
import controlP5.*;
import java.util.*;

//window width and heights for easy changes
final int W = 1920;
final int H = 1200;

private final int TOOL_PANEL_WIDTH = 80;

private static color currentColor;
private String currentBrushType;
private int currentBrushRadius;
private ToolPanel toolPanel;
private BrushFactory brushFactory;
private ControlP5 cp5;

// Spout objects
Spout spoutOut;
Spout spoutIn;
// OSC objects
OscP5 oscP5;
NetAddress myRemoteLocation;
// PGraphics objects for layers
PGraphics originalLayer;
PGraphics spoutInLayer;

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

// to store all shapes created
private ArrayList<Polygon> polygons;

void setup()
{
  //fullScreen();
  size(1920, 1200, P3D); //change accordingly to W and H above
  textureMode(NORMAL);
  //surface.setResizable(true);
  
  background(0);
  frameRate(60);
  cursor(CROSS);
  currentColor = color(255);
  cp5 = new ControlP5(this);
  toolPanel = new ToolPanel(0, 0, TOOL_PANEL_WIDTH, height, color(0), cp5);
  brushFactory = new BrushFactory();
  
  //// spout objects
  spoutOut = new Spout(this);
  spoutIn = new Spout(this);
  //spoutIn.createReceiver("Screen 2 - Resolume Arena");
  
  // OSC object
  oscP5 = new OscP5(this,7000);
  myRemoteLocation = new NetAddress("localhost",12001);
  
  //the two layers
  originalLayer = createGraphics(W,H,P2D);
  spoutInLayer = createGraphics(W,H,PConstants.P2D);
  polygons = new ArrayList<Polygon>();
  currentImagesIndex = 0;
}

void draw()
{
  background(0); //necessary for spout to work properly, else spout frames will accumulate on screen
  spoutInLayer = spoutIn.receiveTexture(spoutInLayer); //puts the spout input onto the layer
  
  currentColor = color(toolPanel.getColor());
  currentBrushType = toolPanel.getBrushType();
  currentBrushRadius = toolPanel.getBrushRadius();
  stroke(1);
  smooth();
  originalLayer.beginDraw();  //draw on that particular layer only
  // Now if the mouse is pressed, paint
  if (mousePressed && mouseX>TOOL_PANEL_WIDTH && toolPanel.isPanelMinimized()) {
    originalLayer.noStroke();
    originalLayer.noFill();
    originalLayer.stroke(currentColor);
    originalLayer.strokeWeight(5);
    if (pmouseX == 0 || pmouseY == 0) {
      originalLayer.line(mouseX, mouseY, mouseX, mouseY);
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
    //println(mouseX);
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
  originalLayer.endDraw();  //end of things to draw on the particular layer

  // animate drips dropping if there are any
  for (Drip drip: drips)
  {
    drip.render();
  }
  
  for (Polygon poly: polygons)
  {
    poly.display();
  }
   
  toolPanel.render();
    //for testing of layers
  //spoutInLayer.beginDraw();
  //spoutInLayer.fill(#220000);
  //spoutInLayer.rect(random(W),random(H),20,20);
  //spoutInLayer.endDraw();
  
  //layer arrangement 
  image(spoutInLayer,0,0); //spout input at the bottom
  image(originalLayer,0,0); //original line on top
  
  spoutOut.sendTexture(originalLayer); //send the paint out via spout
  
} //end of draw


void keyPressed()
{
  if (key == ' ')
  {
    originalLayer.beginDraw();
    originalLayer.clear();
    //spoutInLayer.clear();
    originalLayer.endDraw();
    
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
  //if (key == '1')
  //{
  //  image(images[currentImagesIndex-2], 0, 0);
  //}
}

void mouseReleased()
{
  //images[currentImagesIndex++] = get();
  
  if (mouseX > TOOL_PANEL_WIDTH && currentBrushType == "bolt")
  {
    int[] temp = {mouseX,mouseY};
    boltCoordinates[1] = temp;
    println(Arrays.deepToString(boltCoordinates));
    polygons.add(new Polygon(brushFactory.createBoltShape(boltCoordinates[0], boltCoordinates[1])));
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
      println(Arrays.deepToString(boltCoordinates));
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
    // Spout installation required
    spoutOut.selectSender();
  }
}

public static void addDrip(Drip drip)
{
  drips.add(drip);
}