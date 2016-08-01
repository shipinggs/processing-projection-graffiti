private class BrushFactory {
  private PImage solidImg = loadImage("solid.png");
  private PImage featheredImg = loadImage("feathered.png");
  private PImage grittyImg = loadImage("gritty.png");
  
  
  void solidBrush(int brushRadius, color col)
  {
    strokeWeight(brushRadius*1.8);
    stroke(col);
    if (pmouseX == 0 || pmouseY == 0)
    {
      line(mouseX, mouseY, mouseX, mouseY);
    }
    else
    {
      line(mouseX, mouseY, pmouseX, pmouseY);
    }
  }
  
  void featheredBrush(int brushRadius, color col)
  {
    int thickness = brushRadius * 2;
    for(int i = 0; i < thickness; i+=5)
    {
      strokeWeight(i);
      stroke(col, 5);
      if (pmouseX == 0 || pmouseY == 0)
      {
        line(mouseX, mouseY, mouseX, mouseY);
      }
      else
      {
        line(mouseX, mouseY, pmouseX, pmouseY);
      }
    }
  }
  
  void grittyBrush(int brushRadius, color col) {
    int maxIterations = 150; // how fast spraying happens
   
    float radx;   // Radius
    float rady;
    float angle; // angle
    float x;      // result
    float y;
    
    stroke(col);
    
    for (int i=0; i < maxIterations; i++)
    {
      radx=min(random(brushRadius), random(brushRadius));
      rady=min(random(brushRadius),random(brushRadius));
      radx=min(radx, random(brushRadius));
      rady=min(rady, random(brushRadius));
      angle= random(360);
      //
      x=(radx*cos(radians(angle)))+mouseX;
      y=(radx*sin(radians(angle)))+mouseY;
      //
      stroke(col);
      point(x, y);
    }
  }
  
  void rollerEraser(int width, color col)
  {
    fill(col);
    noStroke();
    rect(mouseX-width/2, mouseY-10, width, 20);
  }
    
  void drawSolidBrushPrint(int brushRadius, float posX, float posY)
  {
    image(solidImg, posX, posY, brushRadius, brushRadius);
  }
  
  void drawFeatheredBrushPrint(int brushRadius, float posX, float posY)
  {
    image(featheredImg, posX, posY, brushRadius, brushRadius);
  }
  
  void drawGrittyBrushPrint(int brushRadius, float posX, float posY)
  {
    image(grittyImg, posX, posY, brushRadius, brushRadius);
  }
}