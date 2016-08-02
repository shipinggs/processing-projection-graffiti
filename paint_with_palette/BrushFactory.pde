private class BrushFactory {
  private PImage solidImg = loadImage("solid.png");
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
    int thickness = brushRadius * 2;
    for(int i = 0; i < thickness; i+=5)
    {
      strokeWeight(i);
      stroke(col, 10);
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
  
  void dripBrush(int brushRadius, color col)
  {
    //draw the dot at our cursor
    noStroke(); // no stroke on ellipses
    ellipse(mouseX, mouseY, 50, 50); // draw a dot at the mouse position with the diameter calculated above
     
    // draw a line to smooth spaces between dots
    stroke(col); // kill the stroke
    strokeWeight(brushRadius*2); // make the line the same width as the dot
    line(mouseX, mouseY, pmouseX, pmouseY); // connect the dots with a line
    
    //Draw the drips
    float chance = random(1,8)*random(1,8)*random(1,8);
    if (chance < 20)
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