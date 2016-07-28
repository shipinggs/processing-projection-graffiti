private class ColorPalette {
  // Setting up colour values
  private final int YELLOW = color(255, 255, 0);
  private final int RED = color(255, 0, 0);
  private final int GREEN = color(0, 255, 0);
  private final int BLUE = color(0, 0, 255);
  private final int GRAY = color(102);
  private final int LIGHT_GRAY = color(200);
  
  private PImage img;
  
  // Coordinates of top-left corner of ColorPalette
  private int coordX, coordY;
  
  // To determine if ColorPalette is minimized
  private boolean paletteIsMinimized = true;
  
  public ColorPalette(int coordX, int coordY) {
    this.coordX = coordX;
    this.coordY = coordY;
    this.coordX -= 1000;
  }
  
  private void init() {
  }
  
  public void render() {
    noStroke();
    fill(LIGHT_GRAY);
    rect(coordX, coordY, 190, 70);
    fill(YELLOW);
    rect(coordX+10,coordY+10,20,20);
    fill(RED);
    rect(coordX+40,coordY+10,20,20);
    fill(GREEN);
    rect(coordX+70,coordY+10,20,20);
    fill(BLUE);
    rect(coordX+100,coordY+10,20,20); 
  }
  
  public void toggleMinimize() {
    if (paletteIsMinimized) {
      img = get();
      coordX += 1000;
    } else {
      coordX -= 1000;
      background(0);
      image(img, 0, 0);
    }
    paletteIsMinimized = !paletteIsMinimized;
  }
}