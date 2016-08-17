private class ToolPanel {
  private String position;
  private float panelPosX, panelPosY, panelWidth, panelHeight;
  private int panelColor;
  private ControlP5 cp5;
  private ColorPalette colorPalette;
  private BrushPalette brushPalette;
  private float colorPaletteHeight, brushPaletteHeight;
    
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
        break;
      case "top":
      case "bottom":
        panelWidth = width;
        panelHeight = height * 0.1;
        panelPosX = 0;
        panelPosY = position == "top" ? 0 : height - panelHeight;
        break;
    }
    
    brushPaletteHeight = panelHeight/5*3;
    colorPaletteHeight = height - brushPaletteHeight;
    brushPalette = new BrushPalette(panelPosX, panelPosY, panelWidth, brushPaletteHeight, cp5, panelColor);
    colorPalette = new ColorPalette(panelPosX, panelHeight/5*3, panelWidth, colorPaletteHeight, panelColor);
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
      paintLayer.rect(panelPosX+(panelWidth/2)-panelWidth*0.3, panelPosY+(panelHeight/2), panelWidth*0.6, 3);
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