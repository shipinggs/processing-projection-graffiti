private class BrushPalette {
  // BrushPalette attributes
  private float posX, posY, paletteWidth, paletteHeight;
  private String panelPosition;
  private color paletteColor;
  
  private ControlP5 cp5;
  
  // Brush attributes
  private String currentBrushType = "feathered";
  private int currentBrushRadius;
  private int currentBrushIndex;
  
  // To determine if BrushPalette is minimized
  private boolean paletteIsMinimized = true;
  
  // define the display size of brushes
  private float displayBrushDiam, displayBrushPadding, displayBrushPaletteHeight, displayBrushPaletteWidth;
  private float singleBrushButtonDiam, displayBrushStartPosX, displayBrushStartPosY;
  private float sliderPosX, sliderPosY, sliderWidth, sliderHeight;
  
  private BrushFactory brushFactory;
  private String[] brushTypes = { "bolt", "lightBolt", "explosion", "crown", "eraser", "drip", "solid", "gritty", "feathered" };
  private List<String> brushTypesList = Arrays.asList(brushTypes);
  
  // brush radius slider
  Slider slider;
  
  public BrushPalette(float posX, float posY, float paletteWidth, float paletteHeight, ControlP5 cp5, color paletteColor, String panelPosition)
  {
    this.posX = posX;
    this.posY = posY;
    this.paletteWidth = paletteWidth;
    this.paletteHeight = paletteHeight;
    this.cp5 = cp5;
    this.paletteColor = paletteColor;
    this.panelPosition = panelPosition;
    init();
  }

  private void init()
  {
    brushFactory = new BrushFactory();
    currentBrushIndex = brushTypesList.indexOf(currentBrushType);
    switch(panelPosition)
    {
      case "left":
      case "right":
        displayBrushPaletteWidth = paletteWidth;
        displayBrushPaletteHeight = paletteHeight/4*3;
        displayBrushPadding = paletteWidth*0.15;
        displayBrushDiam = (displayBrushPaletteHeight/brushTypes.length) - displayBrushPadding;
        displayBrushStartPosX = posX + paletteWidth/2 - displayBrushDiam/2;
        displayBrushStartPosY = posY + displayBrushPadding/2;
        sliderPosX = posX + 1;
        sliderPosY = posY + displayBrushPaletteHeight;
        sliderWidth = paletteWidth;
        sliderHeight = paletteHeight - displayBrushPaletteHeight;
        break;
      case "top":
      case "bottom":
        displayBrushPaletteWidth = paletteWidth/4*3;
        displayBrushPaletteHeight = paletteHeight;
        displayBrushPadding = paletteHeight*0.3;
        displayBrushDiam = (displayBrushPaletteWidth/brushTypes.length) - displayBrushPadding;
        displayBrushStartPosX = posX + displayBrushPadding/2;
        displayBrushStartPosY = posY + paletteHeight/2 - displayBrushDiam/2;
        sliderPosX = posX + displayBrushPaletteWidth;
        sliderPosY = posY;
        sliderWidth = paletteWidth - displayBrushPaletteWidth;
        sliderHeight = paletteHeight;
        break;
    }
    singleBrushButtonDiam = displayBrushDiam + displayBrushPadding;
    
    // add a vertical slider
    slider = cp5.addSlider("brushradius")
       .setPosition(sliderPosX, sliderPosY)
       .setSize((int) sliderWidth, (int) sliderHeight)
       .setRange(0,50)
       .setValue(15)
       .setColor(new CColor(-1,-16110286,-1,-1,-1));
       ;
    
    // reposition the Label for controller 'brushradius'
    cp5.getController("brushradius").getValueLabel().hide();
    cp5.getController("brushradius").getCaptionLabel().hide();
  }
  
  public void render()
  {
    // clear palette
    clearPalette();
    currentBrushRadius = (int) slider.getValue();
    
    if (paletteIsMinimized)
    {
      slider.hide();
    }
    else if (!paletteIsMinimized)
    {
      // draw display brushes
      paintLayer.tint(255, 255);
      for (int i = 0; i < brushTypes.length; i++)
      {
        switch(panelPosition)
        {
          case "left":
          case "right":
            brushFactory.drawDisplayBrushPrint(brushTypes[i], displayBrushDiam, displayBrushStartPosX, displayBrushStartPosY+(i*singleBrushButtonDiam));
            break;
          case "top":
          case "bottom":
            brushFactory.drawDisplayBrushPrint(brushTypes[i], displayBrushDiam, displayBrushStartPosX+(i*singleBrushButtonDiam), displayBrushStartPosY);
            break;
        }
      }
      
      // draw marker to show current brush selected
      paintLayer.fill(255);
      paintLayer.noStroke();
      switch(panelPosition)
      {
        case "left":
        case "right":
          paintLayer.triangle(posX+2, currentBrushIndex*singleBrushButtonDiam+singleBrushButtonDiam/5*2,
              posX+2, currentBrushIndex*singleBrushButtonDiam+singleBrushButtonDiam/5*3,
              posX + paletteWidth*0.1, currentBrushIndex*singleBrushButtonDiam+singleBrushButtonDiam/2);
          break;
        case "top":
        case "bottom":
          paintLayer.triangle(currentBrushIndex*singleBrushButtonDiam+singleBrushButtonDiam/5*2, posY+2,
              currentBrushIndex*singleBrushButtonDiam+singleBrushButtonDiam/5*3, posY+2,
              currentBrushIndex*singleBrushButtonDiam+singleBrushButtonDiam/2, posY + paletteHeight*0.1);
          break;
      }
      
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
    if (!paletteIsMinimized)
    {
      switch(panelPosition)
      {
        case "left":
        case "right":
          if (mouseY < posY + displayBrushPaletteHeight)
          {
            currentBrushIndex = (int) ((mouseY - posY) / singleBrushButtonDiam);
            currentBrushType = brushTypes[currentBrushIndex];
          }
          break;
        case "top":
        case "bottom":
          if (mouseX < posX + displayBrushPaletteWidth)
          {
            currentBrushIndex = (int) ((mouseX - posX) / singleBrushButtonDiam);
            currentBrushType = brushTypes[currentBrushIndex];
          }
          break;
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
  
  public void clearPalette()
  {
    paintLayer.fill(paletteColor);
    paintLayer.noStroke();
    paintLayer.rect(posX, posY, paletteWidth, paletteHeight);
  }
}