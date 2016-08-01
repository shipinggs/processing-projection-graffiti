private class BrushPalette {
  // Coordinates of top-left corner of ColorPalette
  private int posX, posY, paletteWidth, paletteHeight;
  private ControlP5 cp5;
  private final color GREY = color(127);
  
  // Brush attributes
  private String currentBrushType = "solid";
  private int currentBrushRadius = 20;
  
  // To determine if BrushPalette is minimized
  private boolean paletteIsMinimized = true;
  
  // define the display size of brushes
  int displayBrushRadius = 40;
  int displayBrushPaddingX = 20;
  int displayEraserWidth = 100;
  int displayEraserHeight = 15;
      
  private BrushFactory brushFactory;
  private String[] brushTypes = { "solid", "feathered", "gritty", "eraser" };
  
  private int myColor = color(10,10,10);
  Slider slider;
  
  public BrushPalette(int posX, int posY, int paletteWidth, int paletteHeight, ControlP5 cp5)
  {
    this.posX = posX;
    this.posY = posY;
    this.paletteWidth = paletteWidth;
    this.paletteHeight = paletteHeight;
    this.cp5 = cp5;
    init();
  }

  private void init()
  {
    brushFactory = new BrushFactory();
    // add a vertical slider
    slider = cp5.addSlider("brushradius")
       .setPosition(posX+displayBrushPaddingX,posY+paletteHeight/2-5)
       .setSize(paletteWidth/2-(2*displayBrushPaddingX),10)
       .setRange(0,60)
       .setValue(20)
       .setColor(new CColor(-1,-16110286,-1,-1,-1));
       ;
    
    // reposition the Label for controller 'brushradius'
    cp5.getController("brushradius").getValueLabel().align(ControlP5.LEFT, ControlP5.BOTTOM_OUTSIDE).setPaddingX(0);
    cp5.getController("brushradius").getCaptionLabel().align(ControlP5.RIGHT, ControlP5.BOTTOM_OUTSIDE).setPaddingX(0);
  }
  
  public void render()
  {
    currentBrushRadius = (int) slider.getValue();
    // clear palette
    fill(0);
    noStroke();
    rect(posX, posY, paletteWidth, paletteHeight);

    if (paletteIsMinimized)
    {
      // create marker for palette position
      fill(GREY);
      noStroke();
      rect(posX + paletteWidth/2 - 20, posY + paletteHeight/2, 40, 2);
      
      // hide slider
      slider.hide();
    }
    else
    {
      fill(0);
      noStroke();
      rect(posX, posY, paletteWidth, paletteHeight);
      
      // draw slider
      slider.show();
      
      //// draw brush size guide
      //noFill();
      //stroke(255);
      //strokeWeight(1);
      //ellipse(width-100, height-100, 2*slider.getValue(), 2*slider.getValue());
      
      // draw the different display brushes
      int brushTypeStartPosX = posX + paletteWidth/2 + displayBrushPaddingX/2;
      for (int x = 0; x < brushTypes.length; x++)
      {
        switch(brushTypes[x])
        {
          case "solid":
            brushFactory.drawSolidBrushPrint(displayBrushRadius, brushTypeStartPosX+(x*(displayBrushRadius+displayBrushPaddingX)), posY+paletteHeight/2-displayBrushRadius/2);
            break;
          case "feathered":
            brushFactory.drawFeatheredBrushPrint(displayBrushRadius, brushTypeStartPosX+(x*(displayBrushRadius+displayBrushPaddingX)), posY+paletteHeight/2-displayBrushRadius/2);
            break;
          case "gritty":
            brushFactory.drawGrittyBrushPrint(displayBrushRadius, brushTypeStartPosX+(x*(displayBrushRadius+displayBrushPaddingX)), posY+paletteHeight/2-displayBrushRadius/2);
            break;
          case "eraser":
            fill(122);
            noStroke();
            rect(brushTypeStartPosX+(x*(displayBrushRadius+displayBrushPaddingX)), posY+paletteHeight/2-displayEraserHeight/2, displayEraserWidth, displayEraserHeight);
        }        
      }
    }
  }
  
  public void mouseClicked()
  {
    if (!paletteIsMinimized && mouseX>paletteWidth/2)
    {
      int startPosX = posX + paletteWidth/2;
      int singleBrushButtonWidth = displayBrushRadius + displayBrushPaddingX;
      if (mouseX>startPosX && mouseX<startPosX+displayBrushRadius+displayBrushPaddingX)
      {
        currentBrushType = "solid";
      }
      else if (mouseX>startPosX+singleBrushButtonWidth && mouseX<startPosX+(2*singleBrushButtonWidth))
      {
        currentBrushType = "feathered";
      }
      else if (mouseX>startPosX+(2*singleBrushButtonWidth) && mouseX<startPosX+(3*singleBrushButtonWidth))
      {
        currentBrushType = "gritty";
      }
      else if (mouseX>startPosX+(3*singleBrushButtonWidth))
      {
        currentBrushType = "eraser";
      }
    }
  }
  
  public void minimize()
  {
    paletteIsMinimized = true;
  }

  public void toggleMinimize()
  {
    paletteIsMinimized = !paletteIsMinimized;
  }
  
  public String getBrushType()
  {
    return currentBrushType;
  }
  
  public int getBrushRadius()
  {
    return currentBrushRadius;
  }
  
  void brushradius(float theColor) {
    myColor = color(theColor);
    println("a slider event. setting background to "+theColor);
  }
  
}