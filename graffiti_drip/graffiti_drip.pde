float diam; // width of ellipse and weight of line
float dripRan = random(1); //random size of drips
float dripWidth = random(1); //drip width
 
void setup() {
 fullScreen();
 background(0);
 smooth();
}
 
void draw() {
 fill(57,255,29); // neon green
 diam = max(abs(mouseY - height/2)*.18, 20); // constantly recalculate diameter as a distance from the mouse to the center, and make it 10% of that
 println(diam);
 dripRan = random(10, 200);
 dripWidth = random(.1, 6);
}
 
void mouseDragged(){
   
  //draw the dot at our cursor
  noStroke(); // no stroke on ellipses
  ellipse(mouseX, mouseY, diam, diam); // draw a dot at the mouse position with the diameter calculated above
   
  // draw a line to smooth spaces between dots
  stroke(57,255,20); // kill the stroke
  strokeWeight(diam); // make the line the same width as the dot
  line(mouseX, mouseY, pmouseX, pmouseY); // connect the dots with a line
  
  //Draw the drips
  strokeWeight(.5+dripWidth); //make the weight for the drips
  line(mouseX, mouseY, mouseX, mouseY+dripRan); // draw a line from the current dot straight down, the line is set at 50 in this case
}
 
// save the image press any key
void keyPressed() {
  setup();
}