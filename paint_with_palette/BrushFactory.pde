private class BrushFactory {
  void solidBrush(int brushRadius, color col)
  {
    strokeWeight(brushRadius*2);
    stroke(col);
    if (pmouseX == 0 || pmouseY == 0)
    {
      originalLayer.line(mouseX, mouseY, mouseX, mouseY);  //must draw on the originalLayer layer only
    }
    else
    {
      originalLayer.line(mouseX, mouseY, pmouseX, pmouseY);
    }
  }
  
  void featheredBrush(int brushRadius, color col)
  {
    int thickness = brushRadius * 2;
    for(int i = 0; i < thickness; i+=5)
    {
      strokeWeight(i);
      stroke(col, 5);
      if (pmouseX == 0 || pmouseY == 0)
      {
        line(mouseX, mouseY, mouseX, mouseY);
      }
      else
      {
        line(mouseX, mouseY, pmouseX, pmouseY);
      }
    }
  }
  
  void grittyBrush(int brushRadius, color col) {
    int maxIterations = 150; // how fast spraying happens
   
    float radx;   // Radius
    float rady;
    float angle1; // angle
    float x;      // result
    float y;
    
    stroke(col);
    
    for (int i=0; i < maxIterations; i++) {
      radx=min(random(brushRadius), random(brushRadius));
      rady=min(random(brushRadius),random(brushRadius));
      radx=min(radx, random(brushRadius));
      rady=min(rady, random(brushRadius));
      angle1= random(360);
      //
      x=(radx*cos(radians(angle1)))+mouseX;
      y=(radx*sin(radians(angle1)))+mouseY;
      //
      stroke(col);
      point(x, y);
    }
  }
  
  void rollerEraser(int width, color col)
  {
    fill(col);
    noStroke();
    rect(mouseX-width/2, mouseY-10, width, 20);
  }
    
}