private class BrushPalette {
  // Coordinates of top-left corner of ColorPalette
  private float posX, posY, paletteWidth, paletteHeight;
  private ControlP5 cp5;
  private final color GREY = color(127);
  
  // Brush attributes
  private String currentBrushType = "drip";
  private int currentBrushRadius;
  
  // To determine if BrushPalette is minimized
  private boolean paletteIsMinimized = true;
  
  // define the display size of brushes
  float displayBrushDiam;
  float displayBrushPaddingY;
  float displayBrushPaletteHeight, sliderHeight;
  
  private BrushFactory brushFactory;
  private String[] brushTypes = { "eraser", "drip", "solid", "feathered", "gritty" };
  private List<String> brushTypesList = Arrays.asList(brushTypes);
  
  // brush radius slider
  Slider slider;
  
  public BrushPalette(float posX, float posY, float paletteWidth, float paletteHeight, ControlP5 cp5)
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
    displayBrushPaddingY = paletteWidth*0.4;
    displayBrushPaletteHeight = paletteHeight/4*3;
    sliderHeight = paletteHeight - displayBrushPaletteHeight;
    displayBrushDiam = (displayBrushPaletteHeight/brushTypes.length) - displayBrushPaddingY;
    
    // add a vertical slider
    slider = cp5.addSlider("brushradius")
       .setPosition(posX,posY+displayBrushPaletteHeight)
       .setSize((int) paletteWidth, (int) sliderHeight)
       .setRange(0,50)
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
      slider.hide();
    }
    else if (!paletteIsMinimized)
    {
      fill(0);
      noStroke();
      rect(posX, posY, paletteWidth, paletteHeight);

      // draw the different display brushes
      float brushTypeStartPosY = posY + displayBrushPaddingY/2;
      float brushTypePosX = posX + paletteWidth/2 - displayBrushDiam/2;
      float singleBrushButtonHeight = displayBrushDiam + displayBrushPaddingY;
      
      for (int i = 0; i < brushTypes.length; i++)
      {
        switch(brushTypes[i])
        {
          case "solid":
            brushFactory.drawSolidBrushPrint(displayBrushDiam, brushTypePosX, brushTypeStartPosY+(i*singleBrushButtonHeight));
            break;
          case "drip":
            brushFactory.drawDripBrushPrint(displayBrushDiam, brushTypePosX, brushTypeStartPosY+(i*singleBrushButtonHeight));
            break;
          case "feathered":
            brushFactory.drawFeatheredBrushPrint(displayBrushDiam, brushTypePosX, brushTypeStartPosY+(i*singleBrushButtonHeight));
            break;
          case "gritty":
            brushFactory.drawGrittyBrushPrint(displayBrushDiam, brushTypePosX, brushTypeStartPosY+(i*singleBrushButtonHeight));
            break;
          case "eraser":
            fill(255);
            noStroke();
            rect(brushTypePosX, brushTypeStartPosY, displayBrushDiam, displayBrushDiam);
        }        
      }
      
      // draw marker to show current brush selected
      int currentBrushIndex = brushTypesList.indexOf(currentBrushType);
      fill(255);
      triangle(posX, currentBrushIndex*singleBrushButtonHeight+singleBrushButtonHeight/5*2,
              posX, currentBrushIndex*singleBrushButtonHeight+singleBrushButtonHeight/5*3,
              posX + paletteWidth*0.1, currentBrushIndex*singleBrushButtonHeight+singleBrushButtonHeight/2);
      
      // if mouse is pressed, choose brush selection
      if (mousePressed)
      {
        selectBrush();
      }
      
      // draw slider
      slider.show();
    }
  }
  
  public void selectBrush()
  {
    if (!paletteIsMinimized && mouseY<displayBrushPaletteHeight)
    {
      float singleBrushButtonHeight = displayBrushDiam + displayBrushPaddingY;
      int brushTypesIndex = (int) ((mouseY - posY) / singleBrushButtonHeight);
      currentBrushType = brushTypes[brushTypesIndex];
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
  
  public boolean isPaletteMinimized()
  {
    return paletteIsMinimized;
  }
}