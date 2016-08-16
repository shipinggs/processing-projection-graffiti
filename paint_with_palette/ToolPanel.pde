private class ToolPanel {
  private String orientation;
  private float posX, posY, panelWidth, panelHeight;
  private int panelColor;
  private ControlP5 cp5;
  private ColorPalette colorPalette;
  private BrushPalette brushPalette;
  private float colorPaletteHeight, brushPaletteHeight;
    
  public ToolPanel(String orientation, float posX, float posY, float panelWidth, float panelHeight, int panelColor, ControlP5 cp5)
  {
    this.orientation = orientation;
    this.posX = posX;
    this.posY = posY;
    this.panelWidth = panelWidth;
    this.panelHeight = panelHeight;
    this.panelColor = panelColor; 
    this.cp5 = cp5;
    init();
  }
  
  private void init()
  {
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
}