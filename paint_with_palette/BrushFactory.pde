void featheredBrush(int thickness) {
  for(int i = 0; i < thickness; i+=5)
     {
      strokeWeight(i);
      stroke(255, 5);
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

void grittyBrush(int brushRadius) {
  int maxIterations = 100; // how fast spraying happens

  float radx;   // Radius
  float rady;
  float angle1; // angle
  float x;      // result
  float y;
 
  for (int i=0; i < maxIterations; i++) {
    radx=min(random(brushRadius), random(brushRadius));
    rady=min(random(brushRadius),random(brushRadius));
    //radx=min(radx, random(brushRadius));
    //rady=min(rady, random(brushRadius));
    angle1= random(360);
    //
    x=(radx*cos(radians(angle1)))+mouseX;
    y=(radx*sin(radians(angle1)))+mouseY;
    //
    stroke(20, 178, 40);
    point(x, y);
  }
}