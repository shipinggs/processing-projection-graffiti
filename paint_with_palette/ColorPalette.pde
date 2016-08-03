private class ColorPalette {
  // Set up fixed colors (Desperados palette)
  private final color WHITE = color(255);
  private final color GREY = color(127);
  private final color BLACK = color(0);
  private final color LIGHT_BEER = color(255, 207, 0);
  private final color DARK_BEER = color(248, 174, 1);
  private final color DESPERADOS_GREEN = color(0, 143, 52);
  private final color DESPERADOS_RED = color(229, 42, 19);
  private final color DESPERADOS_BLUE = color(40, 50, 120);
  private final int NUM_FIXED_COLORS = 8;

  // Coordinates of top-left corner of ColorPalette
  private int posX, posY, paletteWidth, paletteHeight;

  // Size of the fixed color boxes
  private float fixedColorHeight;
  private final int currentColorBarHeight = 20;

  private ColorPicker colorPicker;
  private color[] colorArray = { WHITE, LIGHT_BEER, DARK_BEER, DESPERADOS_GREEN, DESPERADOS_RED, DESPERADOS_BLUE, GREY, BLACK };
  private int currentColor = LIGHT_BEER;
  
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
    colorPicker = new ColorPicker(posX, posY+currentColorBarHeight, paletteWidth, (paletteHeight/2)-currentColorBarHeight, LIGHT_BEER);
      
    // To show current color selected
    fill(currentColor);
    noStroke();
    rect(posX, posY, paletteWidth, currentColorBarHeight);
    
    fixedColorHeight = (float) (paletteHeight/2)/NUM_FIXED_COLORS;
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
      rect(posX+(paletteWidth/2)-20, posY+(paletteHeight/2), 40, 3);
    } 
    else
    {
      colorPicker.render();

      // To show current color selected
      fill(currentColor);
      noStroke();
      rect(posX, posY, paletteWidth, currentColorBarHeight);

      // render fixed colors
      for (int i = 0; i < colorArray.length; i++)
      {
        fill(colorArray[i]);
        noStroke();
        rect(posX, posY+(paletteHeight/2)+(i*fixedColorHeight), paletteWidth, fixedColorHeight);
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