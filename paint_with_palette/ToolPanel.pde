private class ToolPanel {
  private String position;
  private float panelPosX, panelPosY, panelWidth, panelHeight;
  private int panelColor;
  private ControlP5 cp5;
  private ColorPalette colorPalette;
  private BrushPalette brushPalette;
  private float brushPalettePosX, brushPalettePosY, brushPaletteHeight, brushPaletteWidth;
  private float colorPalettePosX, colorPalettePosY, colorPaletteHeight, colorPaletteWidth;
    
  public ToolPanel(String position, int panelColor, ControlP5 cp5)
  {
    this.position = position;
    this.panelColor = panelColor; 
    this.cp5 = cp5;
    init();
  }
  
  private void init()
  {
    switch (position)
    {
      case "left":
      case "right":
        panelWidth = width * 0.07;
        panelHeight = height;
        panelPosY = 0;
        panelPosX = position == "left" ? 0 : width - panelWidth;
        brushPaletteWidth = panelWidth;
        brushPaletteHeight = panelHeight/5*3;
        brushPalettePosX = panelPosX;
        brushPalettePosY = panelPosY;
        colorPaletteWidth = panelWidth;
        colorPaletteHeight = height - brushPaletteHeight;
        colorPalettePosX = panelPosX;
        colorPalettePosY = brushPaletteHeight;
        break;
      case "top":
      case "bottom":
        panelWidth = width;
        panelHeight = height * 0.1;
        panelPosX = 0;
        panelPosY = position == "top" ? 0 : height - panelHeight;
        brushPaletteWidth = panelWidth/5*3;
        brushPaletteHeight = panelHeight;
        brushPalettePosX = panelPosX;
        brushPalettePosY = panelPosY;
        colorPaletteWidth = width - brushPaletteWidth;
        colorPaletteHeight = panelHeight;
        colorPalettePosX = brushPaletteWidth;
        colorPalettePosY = panelPosY;
        break;
    }

    brushPalette = new BrushPalette(brushPalettePosX, brushPalettePosY, brushPaletteWidth, brushPaletteHeight, cp5, panelColor, position);
    colorPalette = new ColorPalette(colorPalettePosX, colorPalettePosY, colorPaletteWidth, colorPaletteHeight, panelColor, position);
    clearPanel();
  }
  
  public void render()
  {
    clearPanel();
    brushPalette.render();
    colorPalette.render();
    if (isPanelMinimized())
    {
      // create marker for palette position
      paintLayer.fill(133);
      paintLayer.noStroke();
      switch(position)
      {
        case "left":
          paintLayer.rect(panelPosX+panelWidth-2, panelPosY+(panelHeight/2)-20, 2, 40);
          break;
        case "right":
          paintLayer.rect(panelPosX, panelPosY+(panelHeight/2)-20, 3, 40);
          break;
        case "top":
          paintLayer.rect(panelPosX+(panelWidth/2)-20, panelPosY+panelHeight-2, 40, 2);
          break;
        case "bottom":
          paintLayer.rect(panelPosX+(panelWidth/2)-20, panelPosY, 40, 2);
          break;
        
      }
    }
  }
  
  public void maximizePanel()
  {
    brushPalette.maximize();
    colorPalette.maximize();
  }
  
  public int getColor()
  {
    return colorPalette.getColor();
  }
  
  public String getBrushType()
  {
    return brushPalette.getBrushType();
  }
  
  public int getBrushRadius()
  {
    return brushPalette.getBrushRadius();
  }
  
  public void minimizeAll()
  {
    colorPalette.minimize();
    brushPalette.minimize();
  }
  
  public boolean isPanelMinimized()
  {
    if (brushPalette.isPaletteMinimized() && colorPalette.isPaletteMinimized())
    {
      return true;
    }
    return false;
  }
  
  public boolean withinPanelArea()
  {
    switch(position)
    {
      case "top":
        if (mouseY < panelHeight) return true;
        break;
      case "bottom":
        if (mouseY > height - panelHeight) return true;
        break;
      case "left":
        if (mouseX < panelWidth) return true;
        break;
      case "right":
        if (mouseX > width - panelWidth) return true;
        break;
    }
    return false;
  }
  
  public void clearPanel()
  {
    paintLayer.fill(panelColor);
    paintLayer.noStroke();
    paintLayer.rect(panelPosX, panelPosY, panelWidth, panelHeight);
  }
}