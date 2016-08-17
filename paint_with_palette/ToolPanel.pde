private class ToolPanel {
  private String position;
  private float posX, posY, panelWidth, panelHeight;
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
        break;
    }
    brushPaletteHeight = panelHeight/5*3;
    colorPaletteHeight = height - brushPaletteHeight;
    brushPalette = new BrushPalette(posX, posY, panelWidth, brushPaletteHeight, cp5, panelColor);
    colorPalette = new ColorPalette(posX, panelHeight/5*3, panelWidth, colorPaletteHeight, panelColor);
    fill(panelColor);
    rect(posX, posY, panelWidth, panelHeight);
  }
  
  public void render()
  {
    paintLayer.fill(panelColor);
    paintLayer.noStroke();
    paintLayer.rect(posX, posY, panelWidth, panelHeight);
    brushPalette.render();
    colorPalette.render();
    if (isPanelMinimized())
    {
      // create marker for palette position
      paintLayer.fill(133);
      paintLayer.noStroke();
      paintLayer.rect(posX+(panelWidth/2)-panelWidth*0.3, posY+(panelHeight/2), panelWidth*0.6, 3);
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
    }
    return false;
  }
}