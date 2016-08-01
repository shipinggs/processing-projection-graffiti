private class BrushPalette {
  // Coordinates of top-left corner of ColorPalette
  private int posX, posY, paletteWidth, paletteHeight;
  private final color GREY = color(127);
  
  // Brush attributes
  private String currentBrushType = "eraser";
  private int currentBrushRadius = 20;
  
  // To determine if BrushPalette is minimized
  private boolean paletteIsMinimized = true;
  
  // define the display size of brushes
  int displayBrushRadius = 40;
  int displayBrushPaddingX = 20;
  int displayEraserWidth = 100;
  int displayEraserHeight = 15;
      
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
      
      // draw the different display brushes
      int brushTypeStartPosX = posX + paletteWidth/2 + displayBrushPaddingX/2;
      for (int x = 0; x < brushTypes.length; x++)
      {
        switch(brushTypes[x])
        {
          case "solid":
            brushFactory.drawSolidBrushPrint(displayBrushRadius, brushTypeStartPosX+(x*(displayBrushRadius+displayBrushPaddingX)), posY);
            break;
          case "feathered":
            brushFactory.drawFeatheredBrushPrint(displayBrushRadius, brushTypeStartPosX+(x*(displayBrushRadius+displayBrushPaddingX)), posY);
            break;
          case "gritty":
            brushFactory.drawGrittyBrushPrint(displayBrushRadius, brushTypeStartPosX+(x*(displayBrushRadius+displayBrushPaddingX)), posY);
            break;
          case "eraser":
            fill(122);
            noStroke();
            rect(brushTypeStartPosX+(x*(displayBrushRadius+displayBrushPaddingX)), posY-displayEraserHeight/2+displayBrushRadius/2, displayEraserWidth, displayEraserHeight);
        }        
      }
    }
  }
  
  public void mouseClicked()
  {
    if (!paletteIsMinimized && mouseX>paletteWidth/2)
    {
      int startPosX = posX + paletteWidth/2;
      if (mouseX>startPosX && mouseX<startPosX+displayBrushRadius+displayBrushPaddingX)
      {
        currentBrushType = "solid";
      }
      else if (mouseX>startPosX+displayBrushRadius+displayBrushPaddingX && mouseX<startPosX+2*(displayBrushRadius+displayBrushPaddingX))
      {
        currentBrushType = "feathered";
      }
      else if (mouseX>startPosX+2*(displayBrushRadius+displayBrushPaddingX) && mouseX<startPosX+3*(displayBrushRadius+displayBrushPaddingX))
      {
        currentBrushType = "gritty";
      }
      else
      {
        currentBrushType = "eraser";
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