private class ToolPanel {
  private int posX, posY, panelWidth, panelHeight, panelColor;
  private ColorPalette colorPalette;
  private BrushPalette brushPalette;
    
  public ToolPanel(int posX, int posY, int panelWidth, int panelHeight, int panelColor)
  {
      this.posX = posX;
      this.posY = posY;
      this.panelWidth = panelWidth;
      this.panelHeight = panelHeight;
      this.panelColor = panelColor;
      init();
  }
  
  private void init()
  {
    colorPalette = new ColorPalette(posX, posY, panelWidth/2, panelHeight);
    brushPalette = new BrushPalette(panelWidth/2, posY, panelWidth/2, panelHeight);
    fill(panelColor);
    rect(posX, posY, panelWidth, panelHeight);
  }
  
  public void render()
  {
    fill(panelColor);
    noStroke();
    rect(posX, posY, panelWidth, panelHeight);
    
    colorPalette.render();
    brushPalette.render();
  }
  
  public void mouseClicked()
  {
    if (mouseX < panelWidth/2)
    {
      colorPalette.toggleMinimize();
    }
    else if (mouseX > panelWidth/2)
    {
      brushPalette.toggleMinimize();
    }
  }
  
  public int getColor()
  {
    return colorPalette.getColor();
  }
  
  public void minimizeAll()
  {
    colorPalette.minimize();
    brushPalette.minimize();
  }
}