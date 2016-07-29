import spout.*;

// Setting up constant colour values
final int YELLOW = color(255,255,0);
final int RED = color(255,0,0);
final int GREEN = color(0,255,0);
final int BLUE = color(0,0,255);
final int GRAY = color(102);
final int LIGHT_GRAY = color(200);

private final int TOOL_PANEL_HEIGHT = 40;

private color currentColor;
private String brushType;
private ToolPanel toolPanel;

void setup()
{
  //fullScreen();
  size(1366, 768);
  background(0,0,0,0);
  frameRate(60);
  currentColor = color(255);
  toolPanel = new ToolPanel(0, height - TOOL_PANEL_HEIGHT, width, TOOL_PANEL_HEIGHT, 0);
}

void draw()
{
  currentColor = color(toolPanel.getColor());
  stroke(5);
  smooth();
  // Now if the mouse is pressed, paint
  if (mousePressed) {
    noStroke();
    noFill();
    stroke(currentColor);
    strokeWeight(20);
    if (pmouseX == 0 || pmouseY == 0) {
      line(mouseX, mouseY, mouseX, mouseY);
    } else {
      line(mouseX, mouseY, pmouseX, pmouseY);
    }
  }
  toolPanel.render();
  
}

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
}