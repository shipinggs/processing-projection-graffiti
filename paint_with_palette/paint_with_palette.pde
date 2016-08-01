import spout.*;
import controlP5.*;


//window width and heights for easy changes
final int W = 1280;
final int H = 800;

private final int TOOL_PANEL_HEIGHT = 50;

private color currentColor;
private String currentBrushType;
private int currentBrushRadius;
private ToolPanel toolPanel;
private BrushFactory brushFactory;
private ControlP5 cp5;

// Spout objects
Spout spoutOut;
Spout spoutIn;
// PGraphics objects for layers
PGraphics originalLayer;
PGraphics spoutInLayer;

void setup()
{
  //fullScreen();
  size(1280, 800, P3D); //change accordingly to W and H above
  textureMode(NORMAL);
  //surface.setResizable(true);
  
  background(0);
  frameRate(180);
  currentColor = color(255);
  cp5 = new ControlP5(this);
  toolPanel = new ToolPanel(0, height - TOOL_PANEL_HEIGHT, width, TOOL_PANEL_HEIGHT, 0, cp5);
  brushFactory = new BrushFactory();
  
  //// spout objects
  spoutOut = new Spout(this);
  spoutIn = new Spout(this);
  spoutIn.createReceiver("Composition - Resolume Arena");
  
  //the two layers
  originalLayer = createGraphics(W,H,P2D);
  spoutInLayer = createGraphics(W,H,PConstants.P2D);
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
  if (mousePressed && mouseY<height-TOOL_PANEL_HEIGHT) {
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
        case "eraser":
          brushFactory.rollerEraser(200, currentColor);
          break;
        default:
          brushFactory.solidBrush(currentBrushRadius, currentColor);
          break;
      }
      print(currentBrushType, currentBrushRadius, currentColor);
    }
    //osc implementation here
  }
  originalLayer.endDraw();  //end of things to draw on the particular layer
  
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
  
  
}//end of draw

void mouseClicked()
{
  if ((mouseY < height) && (mouseY > (height - TOOL_PANEL_HEIGHT)))
  {
   toolPanel.mouseClicked();
  }
  else
  {
    toolPanel.minimizeAll();
  }
}

void mousePressed()
{
  if (mouseY < (height - TOOL_PANEL_HEIGHT))
  {
    toolPanel.minimizeAll();
  }
  if (mouseButton == RIGHT) {  //right click to select spout source
    // Bring up a dialog to select a sender.
    // Spout installation required
    spoutOut.selectSender();
  }
}