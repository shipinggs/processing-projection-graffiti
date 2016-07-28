private class ColorPalette {
  // Setting up colour values
  private final int YELLOW = color(255, 255, 0);
  private final int RED = color(255, 0, 0);
  private final int GREEN = color(0, 255, 0);
  private final int BLUE = color(0, 0, 255);
  private final int GRAY = color(102);
  private final int LIGHT_GRAY = color(200);
  
  // Coordinates of top-left corner of ColorPalette
  private int coordX, coordY;
  
  // To determine if ColorPalette is minimized
  private boolean paletteIsMinimized = false;
  
  public ColorPalette(int coordX, int coordY) {
    this.coordX = coordX;
    this.coordY = coordY;
    
    if (!paletteIsMinimized) {
      noStroke();
      fill(LIGHT_GRAY);
      rect(coordX, coordY, 190, 70);
      fill(YELLOW);
      rect(20,20,20,20);
      fill(RED);
      rect(50,20,20,20);
      fill(GREEN);
      rect(80,20,20,20);
      fill(BLUE);
      rect(110,20,20,20); 
      fill(GRAY);
      rect(140,20,50,50);    //the eraser
      
    }
  }
  
  private void init() {
  }
  
  public void render() {
  }
}