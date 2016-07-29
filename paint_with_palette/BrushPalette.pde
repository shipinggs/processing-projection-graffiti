private class BrushPalette {
  // Coordinates of top-left corner of ColorPalette
  private int posX, posY, paletteWidth, paletteHeight;
  
  
  
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
    fill(122);
    noStroke();
    rect(posX, posY, paletteWidth, paletteHeight);
  }
}