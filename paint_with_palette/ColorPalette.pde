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
  
  private color[] greenShades = { color(27,94,32),color(56,142,60),color(76,175,80),color(129,199,132),color(200,230,201) };
  private color[] tealShades = { color(0,77,64),color(0,121,107),color(0,150,136),color(77,182,172),color(178,223,219) };
  private color[] blueShades = { color(13,71,161),color(25,118,210),color(33,150,243),color(100,181,246),color(187,222,251) };
  private color[] indigoShades = { color(26,35,126),color(48,63,159),color(63,81,181),color(121,134,203),color(197,202,233) };
  private color[] purpleShades = { color(74,20,140),color(123,31,162),color(156,39,176),color(186,104,200),color(225,190,231) };
  private color[] pinkShades = { color(136,14,79),color(194,24,91),color(233,30,99),color(240,98,146),color(248,187,208) };
  private color[] redShades = { color(183,28,28),color(211,47,47),color(244,67,54),color(229,115,115),color(255,205,210) };
  private color[] orangeShades = { color(230,81,0),color(245,124,0),color(255,152,0),color(255,183,77),color(255,224,178) };
  private color[] amberShades = { color(255,111,0),color(255,160,0),color(255,193,7),color(255,213,79),color(255,236,179) };
  private color[] greyShades = { color(0),color(71),color(133),color(194),color(255) };

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