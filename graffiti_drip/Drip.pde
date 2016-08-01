class Drip {
  float posX, initialPosY, posY;
  int col = color(57,255,29);
  float dripRan, dripWidth;

  public Drip(float posX, float posY)
  {
    this.posX = posX;
    this.posY = posY;
    initialPosY = posY;
    init();
  }
  
  private void init()
  {
    dripRan = random(0, 120);
    dripRan = min(dripRan, random(0, 200));
    dripWidth = random(2, 5);
  }
  
  public void render()
  {

    if (posY < initialPosY + dripRan + height)
    {
      stroke(col, 255);
      strokeWeight(dripWidth);
      line(posX, posY, posX, posY);
      ++posY;
    }
  }
}