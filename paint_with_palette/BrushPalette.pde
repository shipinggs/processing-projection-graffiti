private class BrushPalette {
  // Coordinates of top-left corner of ColorPalette
  private int posX, posY, paletteWidth, paletteHeight;
  private ControlP5 cp5;
  private final color GREY = color(127);
  
  // Brush attributes
  private String currentBrushType = "drip";
  private int currentBrushRadius;
  
  // To determine if BrushPalette is minimized
  private boolean paletteIsMinimized = true;
  
  // define the display size of brushes
  int displayBrushDiam = 30;
  int displayBrushPaddingY = 10;
      
  private BrushFactory brushFactory;
  private String[] brushTypes = { "eraser", "solid", "drip", "feathered", "gritty" };
  
  // brush radius slider
  Slider slider;
  
  public BrushPalette(int posX, int posY, int paletteWidth, int paletteHeight, ControlP5 cp5)
  {
    this.posX = posX;
    this.posY = posY;
    this.paletteWidth = paletteWidth;
    this.paletteHeight = paletteHeight;
    this.cp5 = cp5;
    init();
  }

  private void init()
  {
    brushFactory = new BrushFactory();
    // add a vertical slider
    slider = cp5.addSlider("brushradius")
       //.setPosition(posX+(0.1*paletteWidth),posY+(paletteHeight/2)+(0.1*paletteHeight))
       .setPosition(posX,posY+paletteHeight/2)
       .setSize((int) paletteWidth, (int) paletteHeight/2)
       .setRange(0,60)
       .setValue(10)
       .setColor(new CColor(-1,-16110286,-1,-1,-1));
       ;
    
    // reposition the Label for controller 'brushradius'
    cp5.getController("brushradius").getValueLabel().hide();
    cp5.getController("brushradius").getCaptionLabel().hide();
  }
  
  public void render()
  {
    currentBrushRadius = (int) slider.getValue();
    // clear palette
    fill(0);
    noStroke();
    rect(posX, posY, paletteWidth, paletteHeight);

    if (paletteIsMinimized)
    {
      // create marker for palette position
      fill(GREY);
      noStroke();
      rect(posX + paletteWidth/2 - 20, posY + paletteHeight/2, 40, 2);
      
      // hide slider
      slider.hide();
    }
    else
    {
      fill(0);
      noStroke();
      rect(posX, posY, paletteWidth, paletteHeight);

      // draw the different display brushes
      int brushTypeStartPosY = posY + displayBrushPaddingY/2;
      int brushTypePosX = posX + paletteWidth/2 - displayBrushDiam/2;
      for (int i = 0; i < brushTypes.length; i++)
      {
        switch(brushTypes[i])
        {
          case "solid":
            brushFactory.drawSolidBrushPrint(displayBrushDiam, brushTypePosX, brushTypeStartPosY+(i*(displayBrushDiam+displayBrushPaddingY)));
            break;
          case "drip":
            brushFactory.drawDripBrushPrint(displayBrushDiam, brushTypePosX, brushTypeStartPosY+(i*(displayBrushDiam+displayBrushPaddingY)));
            break;
          case "feathered":
            brushFactory.drawFeatheredBrushPrint(displayBrushDiam, brushTypePosX, brushTypeStartPosY+(i*(displayBrushDiam+displayBrushPaddingY)));
            break;
          case "gritty":
            brushFactory.drawGrittyBrushPrint(displayBrushDiam, brushTypePosX, brushTypeStartPosY+(i*(displayBrushDiam+displayBrushPaddingY)));
            break;
          case "eraser":
            fill(255);
            noStroke();
            rect(brushTypePosX, brushTypeStartPosY, displayBrushDiam, displayBrushDiam);
        }        
      }
      
      // draw slider
      slider.show();
    }
  }
  
  public void mouseClicked()
  {
    if (!paletteIsMinimized && mouseY<paletteHeight/2)
    {
      int singleBrushButtonHeight = displayBrushDiam + displayBrushPaddingY;
      if (mouseY>posY && mouseY<posY+displayBrushDiam+displayBrushPaddingY)
      {
        currentBrushType = "eraser";
      }
      else if (mouseY>posY+singleBrushButtonHeight && mouseY<posY+(2*singleBrushButtonHeight))
      {
        currentBrushType = "solid";
      }
      else if (mouseY>posY+(2*singleBrushButtonHeight) && mouseY<posY+(3*singleBrushButtonHeight))
      {
        currentBrushType = "drip";
      }
      else if (mouseY>posY+(3*singleBrushButtonHeight) && mouseY<posY+(4*singleBrushButtonHeight))
      {
        currentBrushType = "feathered";
      }
      else if (mouseY>posY+(4*singleBrushButtonHeight))
      {
        currentBrushType = "gritty";
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