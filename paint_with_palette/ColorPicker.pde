/**
 * Code sourced from https://forum.processing.org/one/topic/processing-color-picker.html
 * Adapted and modified by Shi Ping
 * Some portions of the code may appear cryptic as they were kept in the original form.
 * Will refactor if I have spare time for this project :)
 */

public class ColorPicker 
{
  int x, y, w, h, c;
  PImage colorPickerImage;
  
  public ColorPicker ( int x, int y, int w, int h, int c ) { // x coord, y coord, width, height, color
    this.x = x;
    this.y = y;
    this.w = w;
    this.h = h;
    this.c = c;
    
    colorPickerImage = new PImage( w, h );
    init();
  }
  
  private void init ()
  {
    // draw color.
    int cw = w;
    for( int i=0; i<cw; i++ ) {
      float nColorPercent = i / (float)cw;
      float rad = (-360 * nColorPercent) * (PI / 180);
      int nR = (int)(cos(rad) * 127 + 128) << 16;
      int nG = (int)(cos(rad + 2 * PI / 3) * 127 + 128) << 8;
      int nB = (int)(Math.cos(rad + 4 * PI / 3) * 127 + 128);
      int nColor = nR | nG | nB;
      
      setGradient( i, 0, h/2, 0xFFFFFF, nColor );
      setGradient( i, (h/2), h/2, nColor, 0x000000 );
    }
  }

  private void setGradient(int x, int y, float h, int c1, int c2 )
  {
    float deltaR = red(c2) - red(c1);
    float deltaG = green(c2) - green(c1);
    float deltaB = blue(c2) - blue(c1);

    for (int j = y; j<(y+h); j++)
    {
      int c = color( red(c1)+(j-y)*(deltaR/h), green(c1)+(j-y)*(deltaG/h), blue(c1)+(j-y)*(deltaB/h) );
      colorPickerImage.set( x, j, c );
    }
  }
  
  public void render()
  {
    image( colorPickerImage, x, y );
  }

}