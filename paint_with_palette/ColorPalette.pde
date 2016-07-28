private class ColorPalette {
  // Set up fixed colors (Desperados palette)
  private final color WHITE = color(255);
  private final color GREY = color(127);
  private final color BLACK = color(0);
  private final color LIGHT_BEER = color(252, 209, 94);
  private final color DARK_BEER = color(248, 174, 1);
  private final color DESPERADOS_GREEN = color(2, 134, 48);
  private final color DESPERADOS_RED = color(184, 32, 11);
  private final int NUM_FIXED_COLORS = 7;
  
  // Coordinates of top-left corner of ColorPalette
  private int posX, posY, paletteWidth, paletteHeight;
  private int currentColor = WHITE;
  
  // Size of the fixed color boxes
  private float fixedColorWidth;
  private final int fixedColorHeight = 30;
  
  private ColorPicker colorPicker;
  private color[] colorArray = { WHITE, LIGHT_BEER, DARK_BEER, DESPERADOS_GREEN, DESPERADOS_RED, GREY, BLACK };
  
  // To determine if ColorPalette is minimized
  private boolean paletteIsMinimized = true;
    
  private ColorPalette(int posX, int posY, int paletteWidth, int paletteHeight)
  {
    this.posX = posX;
    this.posY = posY;
    this.paletteWidth = paletteWidth;
    this.paletteHeight = paletteHeight;
    init();
  }
  
  private void init()
  {
    colorPicker = new ColorPicker(posX, posY + fixedColorHeight, paletteWidth, paletteHeight - fixedColorHeight, 255);
    fixedColorWidth = (float) paletteWidth/NUM_FIXED_COLORS;
  }
  
  public void render()
  { 
    fill(0);
    noStroke();
    rect(posX, posY, paletteWidth, paletteHeight);
    
    if (paletteIsMinimized)
    {
      // create marker for palette position
      fill(WHITE);
      noStroke();
      rect(paletteWidth-2, posY, 2, 4);
    } 
    else
    {
      colorPicker.render();
      
      // To show current color selected
      fill(currentColor);
      noStroke();
      rect(posX, posY, paletteWidth, 5);
      
      for (int i = 0; i < colorArray.length; i++)
      {
        fill(colorArray[i]);
        noStroke();
        rect(i*fixedColorWidth, posY+5, fixedColorWidth,fixedColorHeight);
      }
         
      if (mousePressed && mouseX >= posX && mouseX < posX + paletteWidth && mouseY >= posY && mouseY < posY + paletteHeight) {
        currentColor = get( mouseX, mouseY );
        println(getColor());
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
  
  public int getColor() {
    return currentColor;
  }
}