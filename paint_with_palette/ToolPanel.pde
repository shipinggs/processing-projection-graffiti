private class ToolPanel {
  private int posX, posY, panelWidth, panelHeight, panelColor;
  private ColorPalette colorPalette;
    
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
    colorPalette = new ColorPalette(0, panelHeight/4*3, panelWidth, panelHeight/4);
    fill(panelColor);
    rect(posX, posY, panelWidth, panelHeight);
  }
  
  public void render()
  {
    fill(panelColor);
    noStroke();
    rect(posX, posY, panelWidth, panelHeight);
    
    colorPalette.render();
  }
  
  public void mouseClicked()
  {
    if ((mouseY>panelHeight/4*3)) {
      colorPalette.toggleMinimize();
    }
  }
  
  public int getColor()
  {
    return colorPalette.getColor();
  }
  
  public void minimizeAll()
  {
    colorPalette.minimize();
  }
}