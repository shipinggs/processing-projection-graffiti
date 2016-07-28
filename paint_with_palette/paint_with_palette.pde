// Setting up constant colour values
final int YELLOW = color(255,255,0);
final int RED = color(255,0,0);
final int GREEN = color(0,255,0);
final int BLUE = color(0,0,255);
final int GRAY = color(102);
final int LIGHT_GRAY = color(200);


color currentColor;
ToolPanel toolPanel;

void setup()
{
size(1366, 768);
background(0,0,0,0);
frameRate(240);
currentColor = color(255);
toolPanel = new ToolPanel(0, 0, 200, 768, 125);
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
   toolPanel.mouseClicked();
}

void mousePressed()
{
  //rectangles
  if ((mouseX>20) && (mouseY>20) && (mouseX<40) && (mouseY<40))
  {
    currentColor = color(YELLOW);
  }
  if ((mouseX>50) && (mouseY>20) && (mouseX<70) && (mouseY<40))
  {
    currentColor = color(RED);
  }
  if ((mouseX>80) && (mouseY>20) && (mouseX<100) && (mouseY<40))
  {
    currentColor = color(GREEN);
  }
  if ((mouseX>110) && (mouseY>20) && (mouseX<130) && (mouseY<40))
  {
    currentColor = color(BLUE);
  }
  if ((mouseX>140) && (mouseY>20) && (mouseX<190) && (mouseY<70))
  {
    currentColor = color(GRAY);
  }
}