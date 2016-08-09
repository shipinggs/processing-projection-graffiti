private class ToolPanel {
  private int posX, posY, panelWidth, panelHeight, panelColor;
  private ControlP5 cp5;
  private ColorPalette colorPalette;
  private BrushPalette brushPalette;
    
  public ToolPanel(int posX, int posY, int panelWidth, int panelHeight, int panelColor, ControlP5 cp5)
  {
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
    brushPalette = new BrushPalette(posX, posY, panelWidth, panelHeight/5*3, cp5);
    colorPalette = new ColorPalette(posX, panelHeight/5*3, panelWidth, panelHeight/5*2);
    fill(panelColor);
    rect(posX, posY, panelWidth, panelHeight);
  }
  
  public void render()
  {
    fill(panelColor);
    noStroke();
    rect(posX, posY, panelWidth, panelHeight);
    
    brushPalette.render();
    colorPalette.render();
  }
  
  public void mouseClicked()
  {
    if (mouseY < panelHeight/2)
    {
      brushPalette.mouseClicked();
      brushPalette.toggleMinimize();
    }
    else if (mouseY > panelHeight/2)
    {
      colorPalette.toggleMinimize();
    }
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
}