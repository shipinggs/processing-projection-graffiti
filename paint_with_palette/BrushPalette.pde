private class BrushPalette {
  // Coordinates of top-left corner of ColorPalette
  private int posX, posY, paletteWidth, paletteHeight;
  private final color GREY = color(127);
  
  // Brush attributes
  private String currentBrushType = "solid";
  private int currentBrushRadius = 20;
  
  // To determine if BrushPalette is minimized
  private boolean paletteIsMinimized = true;
  
  private BrushFactory brushFactory;
  private String[] brushTypes = { "solid", "feathered", "gritty", "eraser" };
  
  public BrushPalette(int posX, int posY, int paletteWidth, int paletteHeight)
  {
    this.posX = posX;
    this.posY = posY;
    this.paletteWidth = paletteWidth;
    this.paletteHeight = paletteHeight;
    init();
  }

  private void init()
  {
    brushFactory = new BrushFactory();
  }
  
  public void render()
  {
    fill(0);
    noStroke();
    rect(posX, posY, paletteWidth, paletteHeight);

    if (paletteIsMinimized)
    {
      // create marker for palette position
      fill(GREY);
      noStroke();
      rect(posX + paletteWidth/2 - 20, posY + paletteHeight/2, 40, 2);
    }
    else
    {
      fill(0);
      noStroke();
      rect(posX, posY, paletteWidth, paletteHeight);
      
      // define the display size of brushes
      int displayBrushRadius = 40;
      int paddingX = 20;
      int displayEraserWidth = 100;
      int displayEraserHeight = 15;
      
      // draw the different display brushes
      int brushTypeStartPosX = posX + paletteWidth/2 + paddingX;
      for (int x = 0; x < brushTypes.length; x++)
      {
        switch(brushTypes[x])
        {
          case "solid":
            brushFactory.drawSolidBrushPrint(displayBrushRadius, brushTypeStartPosX+(x*(displayBrushRadius+paddingX)), posY);
            break;
          case "feathered":
            brushFactory.drawFeatheredBrushPrint(displayBrushRadius, brushTypeStartPosX+(x*(displayBrushRadius+paddingX)), posY);
            break;
          case "gritty":
            brushFactory.drawGrittyBrushPrint(displayBrushRadius, brushTypeStartPosX+(x*(displayBrushRadius+paddingX)), posY);
            break;
          case "eraser":
            fill(122);
            noStroke();
            rect(brushTypeStartPosX+(x*(displayBrushRadius+paddingX)), posY-displayEraserHeight/2+displayBrushRadius/2, displayEraserWidth, displayEraserHeight);
        }        
      }
    }
  }
  
  public void minimize()
  {
    paletteIsMinimized = true;
  }

  public void toggleMinimize()
  {
    paletteIsMinimized = !paletteIsMinimized;
  }
  
  public String getBrushType()
  {
    return currentBrushType;
  }
  
  public int getBrushRadius()
  {
    return currentBrushRadius;
  }
  
}