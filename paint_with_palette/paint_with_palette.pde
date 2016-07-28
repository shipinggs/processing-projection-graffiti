// Setting up constant colour values
final int YELLOW = color(255,255,0);
final int RED = color(255,0,0);
final int GREEN = color(0,255,0);
final int BLUE = color(0,0,255);
final int GRAY = color(102);
final int LIGHT_GRAY = color(200);

color currentColor;
boolean typeIsRect;

void setup()
{
size(480,640);
background(0,0,0,0);
frameRate(60);
currentColor = color(102);
typeIsRect = true;
}

void draw() {
  stroke(5);
  smooth();
  ColorPalette palette = new ColorPalette(10, 10);
  
  // Now if the mouse is pressed, paint
  if (mousePressed) {
    noStroke();
    fill(currentColor);
    stroke(currentColor);
    strokeWeight(5);
    line(mouseX, mouseY, pmouseX, pmouseY);
    println(mouseX, mouseY);
  }
}

void mousePressed() {
  //rectangles
  if ((mouseX>20) && (mouseY>20) && (mouseX<40) && (mouseY<40))
  {
    typeIsRect = true;
    currentColor = color(YELLOW);
  }
  if ((mouseX>50) && (mouseY>20) && (mouseX<70) && (mouseY<40))
  {
    typeIsRect = true;
    currentColor = color(RED);
  }
  if ((mouseX>80) && (mouseY>20) && (mouseX<100) && (mouseY<40))
  {
    typeIsRect = true;
    currentColor = color(GREEN);
  }
  if ((mouseX>110) && (mouseY>20) && (mouseX<130) && (mouseY<40))
  {
    typeIsRect = true;
    currentColor = color(BLUE);
  }
  if ((mouseX>140) && (mouseY>20) && (mouseX<190) && (mouseY<70))
  {
    typeIsRect = true;
    currentColor = color(GRAY);
  }
}