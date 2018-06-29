class BasicInst implements Instrument
{
  protected float t;
  protected float l;
  protected float h;
  protected float w;
  protected IntList n;
  protected String name;
  protected int[][] c = {
      {0, 66, 66},{27, 66, 66},{39, 66, 66},
      {49, 66, 66},{60, 66, 66},{80, 66, 63},
      {120, 66, 53},{180, 66, 40},{223, 59, 44},
      {253, 58, 45},{278, 63, 44},{326, 66, 53}
    };
  protected ArrayList<Block> blocks;
  protected final float delay = 0.5;
  
  BasicInst(String str)
  {
    t = 0;
    l = 0;
    h = 0;
    w = 0;
    name = str;
    blocks = new ArrayList<Block>();
  }
  
  void setCanvas(float x1, float y1, float x2, float y2)
  {
    t = y1;
    l = x1;
    h = y2-y1;
    w = x2-x1;
    n = new IntList();
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
  
  public int toNote(String str, int i)
  {
    switch(str)
    {
      case "c":
        return 0+i*12+24;
      case "c#":
        return 1+i*12+24;
      case "d":
        return 2+i*12+24;
      case "d#":
        return 3+i*12+24;
      case "e":
        return 4+i*12+24;
      case "f":
        return 5+i*12+24;
      case "f#":
        return 6+i*12+24;
      case "g":
        return 7+i*12+24;
      case "g#":
        return 8+i*12+24;
      case "a":
        return 9+i*12+24;
      case "a#":
        return 10+i*12+24;
      case "b":
        return 11+i*12+24;
    }
    return 0;
  }
  
  color colorScheme(int i)
  {
    return color(c[i][0],c[i][1],c[i][2]);
  }
  
  protected void removeBlock()
  {
    blocks.remove(0);
    float temp_w = w/blocks.size();
    for(int i = 0; i < blocks.size(); i++)
      blocks.get(i).moveTo(l+temp_w*i,t,temp_w,h);
  }
  
  protected void addBlock()
  {
    float temp_w = w/(blocks.size()+1);
    blocks.add(new Block(l+temp_w*blocks.size(),t,0,h,delay));
    for(int i = 0; i < blocks.size(); i++)
      blocks.get(i).moveTo(l+temp_w*i,t,temp_w,h);
  }
  
  protected void displayBlocks()
  {
    for(int i = 0; i < blocks.size(); i++)
    {
      blocks.get(i).draw();
    }
  }
  
  void draw(Note[] notes)
  { 
    for(int i = 0; i < notes.length; i++)
    {
      int pitch = notes[i].relativePitch()%12;
      if(!n.hasValue(pitch))
      {
        n.append(pitch);
        addBlock();
      }
    }
    n.sort();
    
    for(int i = 0; i < notes.length; i++)
    {
      int pitch = notes[i].relativePitch()%12;
      int velocity = notes[i].velocity();
      int j=0;
      for(;j<n.size();j++)
        if(n.get(j)==pitch)
          break;
      
      blocks.get(j)
        .setColor(color(c[pitch][0],c[pitch][1],c[pitch][2]))
        .setAlpha(velocity)
      ;
    }
    
    displayBlocks();
    textSize(h);
    fill(0);
    text(name, l+w/2, t+(7*h)/8); 
  }
}