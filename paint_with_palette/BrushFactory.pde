private class BrushFactory {
  private PImage boltImg = loadImage("bolt.png");
  private PImage solidImg = loadImage("solid.png");
  private PImage dripImg = loadImage("drip.png");
  private PImage featheredImg = loadImage("feathered.png");
  private PImage grittyImg = loadImage("gritty.png");

  
  void solidBrush(int brushRadius, color col)
  {
    paintLayer.strokeWeight(brushRadius*2);
    paintLayer.stroke(col);
    if (pmouseX == 0 || pmouseY == 0)
    {
      paintLayer.line(mouseX, mouseY, mouseX, mouseY);
    }
    else
    {
      paintLayer.line(mouseX, mouseY, pmouseX, pmouseY);
    }
  }
  
  void featheredBrush(int brushRadius, color col)
  {
    float thickness = brushRadius * 2;
    int MAX_TIMES_DRAWN = 10;
    int count = 0;
    
    paintLayer.stroke(col, 5);
    paintLayer.noFill();
    
    for(int i = (int) thickness; i > 0; i-=3)
    {
      if (count < MAX_TIMES_DRAWN)
      {
        paintLayer.strokeWeight(i);
  
        if (pmouseX == 0 || pmouseY == 0)
        {
          paintLayer.line(mouseX, mouseY, mouseX, mouseY);
        }
        else
        {
          paintLayer.line(mouseX, mouseY, pmouseX, pmouseY);
        }
        ++count;
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
    
    paintLayer.stroke(col);
    paintLayer.strokeWeight(1);
    paintLayer.noFill();
    
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
      paintLayer.stroke(col);
      paintLayer.point(x, y);
    }
  }
  
  void dripBrush(int brushRadius, color col)
  {
    paintLayer.stroke(col);
    paintLayer.strokeWeight(brushRadius*2);
    if (pmouseX == 0 || pmouseY == 0)
    {
      paintLayer.line(mouseX, mouseY, mouseX, mouseY);
    }
    else
    {
      paintLayer.line(mouseX, mouseY, pmouseX, pmouseY); // connect the dots with a line
    }

    //Draw the drips
    float chance = random(1,8)*random(1,8)*random(1,8);
    if (chance < 15)
    {
      paint_with_palette.addDrip(new Drip(mouseX, mouseY, brushRadius, col));
    }
  }
  
  void drawBoltShape(color col, int[] coordA, int[] coordB)
  {
    int deltaX = coordB[0] - coordA[0];
    int deltaY = coordB[1] - coordA[1];
    float shapeHeight = (float) Math.sqrt((deltaX*deltaX + deltaY*deltaY));
    float shapeScale = shapeHeight / boltImg.height;
    float angleInDegrees = (float) Math.atan((float)deltaX/deltaY);
    println(angleInDegrees);
    paintLayer.beginDraw();
    paintLayer.tint(col);  // Tint blue
    paintLayer.translate(mouseX-deltaX/2.0, mouseY-deltaY/2.0);
    paintLayer.rotate(-angleInDegrees);
    paintLayer.scale(shapeScale);
    paintLayer.image(boltImg, -boltImg.width/2, -boltImg.height/2);
    paintLayer.endDraw();
  }
  
  void rollerEraser(int width, color col)
  {
    paintLayer.smooth();
    paintLayer.fill(col);
    paintLayer.noStroke();
    paintLayer.rect(mouseX-width/2, mouseY-10, width, 20);
  }
    
  void drawSolidBrushPrint(float brushDiam, float posX, float posY)
  {
    paintLayer.image(solidImg, posX, posY, brushDiam, brushDiam);
  }
  
  void drawDripBrushPrint(float brushDiam, float posX, float posY)
  {
    paintLayer.image(dripImg, posX, posY, brushDiam, brushDiam);
  }
  
  void drawFeatheredBrushPrint(float brushDiam, float posX, float posY)
  {
    paintLayer.image(featheredImg, posX, posY, brushDiam, brushDiam);
  }
  
  void drawGrittyBrushPrint(float brushDiam, float posX, float posY)
  {
    paintLayer.image(grittyImg, posX, posY, brushDiam, brushDiam);
  }
  
  void drawBoltBrushPrint(float brushDiam, float posX, float posY)
  {
    paintLayer.image(boltImg, posX, posY, brushDiam, brushDiam);
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
    if (posY < initialPosY + dripRun)
    {
      seed += 0.07;
      float n = noise(seed);
      paintLayer.noStroke();
      paintLayer.strokeWeight(0);
      paintLayer.fill(col, transparency);
      paintLayer.ellipse(posX, posY, dripWidth*n, dripWidth*n);
      ++posY;
    }
    if ((initialPosY + dripRun - posY) < 0.5*dripRun)
    {
      //transparency -= 5;
    }
    
  }
}