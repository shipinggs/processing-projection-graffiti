private class ToolPanel {
  private int posX, posY, panelWidth, panelHeight, panelColor;
  private ColorPalette colorPalette;
  
  private boolean isColorOpen = true;
  
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
    
    if (isColorOpen) {
      colorPalette.render();
    }
  }
  
  public void mouseClicked() {
    colorPalette.toggleMinimize();
  }
  
  public int getColor() {
    return colorPalette.getColor();
  }
}