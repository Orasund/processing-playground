class OctaveInst implements Instrument
{
  private float t;
  private float l;
  private float h;
  private float w;
  
  OctaveInst()
  {
    t = 0;
    l = 0;
    h = 0;
    w = 0;
  }
  
  void setCanvas(float x1, float y1, float x2, float y2)
  {
    t = y1;
    l = x1;
    h = y2-y1;
    w = x2-x1;
  }
  
  float getTop()
  {
    return t;
  }
  
  float getLeft()
  {
    return l;
  }
  
  float getWidth()
  {
    return w;
  }
  
  float getHeight()
  {
    return h;
  }
  
  color colorScheme(int i)
  {
    int[][] c = {
      {0, 66, 66},{27, 66, 66},{39, 66, 66},
      {49, 66, 66},{60, 66, 66},{80, 66, 63},
      {120, 66, 53},{180, 66, 40},{223, 59, 44},
      {253, 58, 45},{278, 63, 44},{326, 66, 53}
    };
    
    return color(c[i][0],c[i][1],c[i][2]);
  }
  
  void draw(Note[] notes)
  {
    fill(0);
    stroke(255);
    rect(l,t,w,h);
    float temp_w = w/12;
    noStroke();
    
    for(int i = 0; i < notes.length; i++)
    {
      int pitch = notes[i].relativePitch()%12;
      fill(colorScheme(pitch));
      rect(l+temp_w*pitch,t,temp_w,h);
    }
  }
}