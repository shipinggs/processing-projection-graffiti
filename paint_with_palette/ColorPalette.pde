private class ColorPalette {

  // Set up color values of palette
  private color[] greenShades = { color(27, 94, 32), color(56, 142, 60), color(76, 175, 80), color(129, 199, 132), color(200, 230, 201) };
  private color[] tealShades = { color(0, 77, 64), color(0, 121, 107), color(0, 150, 136), color(77, 182, 172), color(178, 223, 219) };
  private color[] blueShades = { color(13, 71, 161), color(25, 118, 210), color(33, 150, 243), color(100, 181, 246), color(187, 222, 251) };
  private color[] indigoShades = { color(26, 35, 126), color(48, 63, 159), color(63, 81, 181), color(121, 134, 203), color(197, 202, 233) };
  private color[] purpleShades = { color(74, 20, 140), color(123, 31, 162), color(156, 39, 176), color(186, 104, 200), color(225, 190, 231) };
  private color[] pinkShades = { color(136, 14, 79), color(194, 24, 91), color(233, 30, 99), color(240, 98, 146), color(248, 187, 208) };
  private color[] redShades = { color(183, 28, 28), color(211, 47, 47), color(244, 67, 54), color(229, 115, 115), color(255, 205, 210) };
  private color[] orangeShades = { color(230, 81, 0), color(245, 124, 0), color(255, 152, 0), color(255, 183, 77), color(255, 224, 178) };
  private color[] amberShades = { color(255, 111, 0), color(255, 160, 0), color(255, 193, 7), color(255, 213, 79), color(255, 236, 179) };
  private color[] greyShades = { color(0), color(71), color(133), color(194), color(255) };
  private color[][] colorMatrix = { greenShades, tealShades, blueShades, indigoShades, purpleShades, 
    pinkShades, redShades, orangeShades, amberShades, greyShades };

  // ArrayList to hold all the single-color blocks
  private ArrayList<SingleColorBlock> singleColorBlocks = new ArrayList<SingleColorBlock>();

  // ColorPalette attributes
  private float posX, posY, paletteWidth, paletteHeight;
  private String panelPosition;
  private color paletteColor;

  // Size of each color rectangle
  private float singleColorHeight, singleColorWidth;

  private int currentColor;
  private boolean paletteIsMinimized = true;

  private ColorPalette(float posX, float posY, float paletteWidth, float paletteHeight, color paletteColor, String panelPosition)
  {
    this.posX = posX;
    this.posY = posY;
    this.paletteWidth = paletteWidth;
    this.paletteHeight = paletteHeight;
    this.paletteColor = paletteColor;
    this.panelPosition = panelPosition;
    init();
  }

  private void init()
  {   
    currentColor = colorMatrix[0][0];    

    // initialize color palette single blocks from pre-set color matrix
    for (int i = 0; i < colorMatrix.length; i++)
    {
      for (int j = 0; j < colorMatrix[i].length; j++)
      {
        switch(panelPosition)
        {
          case "left":
          case "right":
            singleColorWidth = paletteWidth / colorMatrix[0].length;
            singleColorHeight = paletteHeight / colorMatrix.length;
            singleColorBlocks.add(new SingleColorBlock(
              posX+(j*singleColorWidth), posY+(i*singleColorHeight), 
              singleColorWidth, singleColorHeight, colorMatrix[i][j], panelPosition));
            break;
          case "top":
          case "bottom":
            singleColorWidth = paletteWidth / colorMatrix.length;
            singleColorHeight = paletteHeight / colorMatrix[0].length;
            singleColorBlocks.add(new SingleColorBlock(
              posX+(i*singleColorWidth), posY+(j*singleColorHeight), 
              singleColorWidth, singleColorHeight, colorMatrix[i][4-j], panelPosition));
            break;
        }
      }
    }
  }

  public void render()
  { 
    // erase everything in the palette
    clearPalette();

    if (!paletteIsMinimized)
    {
      for (SingleColorBlock singleBlock : singleColorBlocks)
      {
        singleBlock.render();
      }

      if (mousePressed && mouseX >= posX && mouseX < posX + paletteWidth && mouseY >= posY && mouseY < posY + paletteHeight)
      {
        currentColor = paintLayer.get().get( mouseX, mouseY );
      }
    }
  }

  public void minimize()
  {
    paletteIsMinimized = true;
  }

  public void maximize()
  {
    paletteIsMinimized = false;
  }

  public int getColor() {
    return currentColor;
  }

  public boolean isPaletteMinimized()
  {
    return paletteIsMinimized;
  }
  
  public void clearPalette()
  {
    paintLayer.fill(paletteColor);
    paintLayer.noStroke();
    paintLayer.rect(posX, posY, paletteWidth, paletteHeight);
  }
}


class SingleColorBlock {
  private color blockColor;
  private float posX, posY, blockWidth, blockHeight;
  private String panelPosition;

  public SingleColorBlock(float posX, float posY, float blockWidth, float blockHeight, color blockColor, String panelPosition)
  {
    this.posX = posX;
    this.posY = posY;
    this.blockWidth = blockWidth;
    this.blockHeight = blockHeight;
    this.blockColor = blockColor;
    this.panelPosition = panelPosition;
  }

  public void render()
  {
    paintLayer.fill(blockColor);
    paintLayer.noStroke();
    paintLayer.rect(posX, posY, blockWidth, blockHeight);

    if (blockColor == paint_with_palette.currentColor)
    {
      paintLayer.fill(255);
      paintLayer.noStroke();
      switch(panelPosition)
      {
        case "left":
        case "right":
          paintLayer.ellipse(posX+(blockWidth/5*3), posY+(blockHeight/4), blockWidth/5*2, blockWidth/5*2);
          break;
        case "top":
        case "bottom":
          paintLayer.ellipse(posX+(blockWidth/6*5), posY+(blockHeight/2), blockHeight/3, blockHeight/3);
          break;
      }
    } 
    else if (paint_with_palette.savedColors.contains(blockColor))
    {
      paintLayer.fill(255);
      paintLayer.noStroke();
      switch(panelPosition)
      {
        case "left":
        case "right":
          paintLayer.rect(posX+(blockWidth/5*3), posY+(blockHeight/6), blockWidth/6, blockWidth/5*3);
          break;
        case "top":
        case "bottom":
          paintLayer.rect(posX+(blockWidth/4*3), posY+(blockHeight/5*2), blockHeight/5*3, blockHeight/6);
          break;
      }
    }
  }
}