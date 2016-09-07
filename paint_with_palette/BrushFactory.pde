/*
 * When adding a new brush image,
 * 1. Load the image "private PImage testImg = loadImage("test.png");"
 * 2. If the brush is a stencil, add it to the String array stencils;
 * 3. Put the brush image into the brushImages Hashmap "brushImages.put("test", testImg);"
 */
 
private class BrushFactory {
  private PImage boltImg = loadImage("bolt.png");
  private PImage lightBoltImg = loadImage("lightbolt.png");
  private PImage explosionImg = loadImage("explosion.png");
  private PImage crownImg = loadImage("crown.png");
  private PImage solidImg = loadImage("solid.png");
  private PImage dripImg = loadImage("drip.png");
  private PImage featheredImg = loadImage("feathered.png");
  private PImage grittyImg = loadImage("gritty.png");
  private PImage eraserImg = loadImage("eraser.png");
  private HashMap<String, PImage> brushImages;
  private String[] stencils = { "bolt", "lightBolt", "explosion", "crown" };
  private List<String> stencilsList = Arrays.asList(stencils); 
  
  public BrushFactory()
  {
    brushImages = new HashMap<String, PImage>();
    brushImages.put("bolt", boltImg);
    brushImages.put("lightBolt", lightBoltImg);
    brushImages.put("explosion", explosionImg);
    brushImages.put("crown", crownImg);
    brushImages.put("solid", solidImg);
    brushImages.put("drip", dripImg);
    brushImages.put("feathered", featheredImg);
    brushImages.put("gritty", grittyImg);
    brushImages.put("eraser", eraserImg);
  }
  
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
    float thickness = brushRadius * 2.4; // this multiplier produces the best result, but feel free to vary
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
    brushRadius *= 1.5;  // this multiplier produces the best result, but feel free to vary
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
  
  
  void drawStencil(String stencilType, color col, int[] coordA, int[] coordB)
  {
    PImage stencilImg = brushImages.get(stencilType);
    float deltaX = coordB[0] - coordA[0];
    float deltaY = coordB[1] - coordA[1];
    float shapeHeight = (float) Math.sqrt((deltaX*deltaX + deltaY*deltaY));
    float shapeScale = shapeHeight / stencilImg.height;
    float angleInDegrees;
    if (deltaY >= 0)
    {
      angleInDegrees = (float) Math.atan(deltaX/deltaY); 
    }
    else
    {
      angleInDegrees = deltaX >= 0 ? (float)-Math.atan(deltaY/deltaX) + PI/2 : (float)-Math.atan(deltaY/deltaX) - PI/2;
    }
    paintLayer.beginDraw();
    paintLayer.tint(col);
    paintLayer.translate(mouseX-deltaX/2.0, mouseY-deltaY/2.0);
    paintLayer.rotate(-angleInDegrees);
    paintLayer.scale(shapeScale);
    paintLayer.image(stencilImg, -stencilImg.width/2, -stencilImg.height/2);
    paintLayer.endDraw();
  }
  
  void rollerEraser(int brushSize, color col)
  {
    int rollerWidth = brushSize * 5;
    int rollerHeight = 20;
    paintLayer.smooth();
    paintLayer.fill(col);
    paintLayer.noStroke();
    paintLayer.rect(mouseX-rollerWidth/2, mouseY-rollerHeight/2, rollerWidth, rollerHeight);
  }
  
  void drawDisplayBrushPrint(String brushType, float brushDiam, float posX, float posY)
  {
    paintLayer.image(brushImages.get(brushType), posX, posY, brushDiam, brushDiam);
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
      transparency -= 5;
    }
    
  }
}