private class BrushPalette {
  // Coordinates of top-left corner of ColorPalette
  private int posX, posY, paletteWidth, paletteHeight;
  private final color GREY = color(127);
  
  // To determine if BrushPalette is minimized
  private boolean paletteIsMinimized = true;
  
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
      fill(GREY);
      noStroke();
      rect(posX, posY, paletteWidth, paletteHeight);
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
  
}