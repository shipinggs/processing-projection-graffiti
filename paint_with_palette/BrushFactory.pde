private class BrushFactory {
  private PImage solidImg = loadImage("solid.png");
  private PImage dripImg = loadImage("drip.png");
  private PImage featheredImg = loadImage("feathered.png");
  private PImage grittyImg = loadImage("gritty.png");

  
  void solidBrush(int brushRadius, color col)
  {
    strokeWeight(brushRadius*2);
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
    float thickness = brushRadius * 2;
    for(int i = 0; i < thickness; i+=2)
    {
      strokeWeight(i);
      stroke(col, 18);
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
  
  void grittyBrush(int brushRadius, color col)
  {
    brushRadius *= 1.5;
    int maxIterations = 200; // how fast spraying happens
   
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
  
  void dripBrush(int brushRadius, color col)
  {
    stroke(col);
    strokeWeight(brushRadius*2);
    line(mouseX, mouseY, pmouseX, pmouseY); // connect the dots with a line
    
    //Draw the drips
    float chance = random(1,8)*random(1,8)*random(1,8);
    if (chance < 15)
    {
      paint_with_palette.addDrip(new Drip(mouseX, mouseY, brushRadius, col));
    }
  }
  
  void rollerEraser(int width, color col)
  {
    fill(col);
    noStroke();
    rect(mouseX-width/2, mouseY-10, width, 20);
  }
    
  void drawSolidBrushPrint(int brushDiam, float posX, float posY)
  {
    image(solidImg, posX, posY, brushDiam, brushDiam);
  }
  
  void drawDripBrushPrint(int brushDiam, float posX, float posY)
  {
    image(dripImg, posX, posY, brushDiam, brushDiam);
  }
  
  void drawFeatheredBrushPrint(int brushDiam, float posX, float posY)
  {
    image(featheredImg, posX, posY, brushDiam, brushDiam);
  }
  
  void drawGrittyBrushPrint(int brushDiam, float posX, float posY)
  {
    image(grittyImg, posX, posY, brushDiam, brushDiam);
  }
}

class Drip {
  float posX, initialPosY, posY;
  color col;
  int brushRadius;
  float dripRun, dripWidth;
  float seed = 0;
  float transparency = 255;

  public Drip(float posX, float posY, int brushRadius, color col)
  {
    this.posX = posX;
    this.posY = posY;
    initialPosY = posY;
    this.brushRadius = brushRadius;
    this.col = col;
    init();
  }
  
  private void init()
  {
    dripRun = random(2*brushRadius, 6*brushRadius);
    dripWidth = random(5, brushRadius);
    noiseSeed(0);
  }
  
  public void render()
  {
    seed += 0.07;
    float n = noise(seed);
    
    if (posY < initialPosY + dripRun)
    {
      noStroke();
      strokeWeight(0);
      fill(col, transparency);
      ellipse(posX, posY, dripWidth*n, dripWidth*n);
      ++posY;
    }
    if ((initialPosY + dripRun - posY) < 0.5*dripRun)
    {
      transparency -= 5;
    }
    
  }
}