import spout.*;
import controlP5.*;
import java.util.*;

private final int TOOL_PANEL_WIDTH = 80;

private static color currentColor;
private String currentBrushType;
private int currentBrushRadius;
private ToolPanel toolPanel;
private BrushFactory brushFactory;
private ControlP5 cp5;

// to store drips created
private static ArrayList<Drip> drips = new ArrayList<Drip>();

// to store last 5 colours used
private static ArrayList<Integer> savedColors = new ArrayList<Integer>();

// to store last 5 undo snapshots
private int NUM_UNDO_ALLOWED = 5;
private PImage[] images = new PImage[NUM_UNDO_ALLOWED];
private int currentImagesIndex;

void setup()
{
  //fullScreen();
  size(1267, 800);
  background(0,0,0,0);
  frameRate(60);
  cursor(CROSS);
  currentColor = color(255);
  cp5 = new ControlP5(this);
  toolPanel = new ToolPanel(0, 0, TOOL_PANEL_WIDTH, height, color(0), cp5);
  brushFactory = new BrushFactory();
  currentImagesIndex = 0;
}

void draw()
{
  currentColor = color(toolPanel.getColor());
  currentBrushType = toolPanel.getBrushType();
  currentBrushRadius = toolPanel.getBrushRadius();
  stroke(5);
  smooth();
  // Now if the mouse is pressed, paint
  if (mousePressed && mouseX>TOOL_PANEL_WIDTH && toolPanel.isPanelMinimized()) {
    noStroke();
    noFill();
    stroke(currentColor);
    strokeWeight(1);
    if (pmouseX == 0 || pmouseY == 0)
    {
      line(mouseX, mouseY, mouseX, mouseY);
    } 
    else {
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
        default:
          brushFactory.solidBrush(currentBrushRadius, currentColor);
          break;
      }
    }
  }
  
  
  // animate drips dropping if there are any
  for (Drip drip: drips)
  {
    drip.render();
  }
   
  toolPanel.render();
  
}

void keyPressed()
{
  if (key == ' ')
  {
    savedColors.clear();
    drips.clear();
    toolPanel.minimizeAll();
    clear();
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
  }
}

private void addUsedColorToMemory()
{
  if (!savedColors.contains(currentColor))
  {
    savedColors.add(currentColor);
  }
}

public static void addDrip(Drip drip)
{
  drips.add(drip);
}