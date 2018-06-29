class Brain
{
  ArrayList<HashMap<Integer,Note>> map;
  Instrument[] instruments;
  HashMap<Integer,Integer> channels;
  float[][] canvas;
  
  Brain(Instrument[] instruments_, int[] channels_, float[][] canvas_)
  {
    instruments = instruments_;
    canvas = canvas_;
    map = new ArrayList<HashMap<Integer,Note>>();
    channels = new HashMap<Integer,Integer>();
    for(int i = 0; i<instruments.length; i++)
    {
      map.add(new HashMap<Integer,Note>());
      channels.put(channels_[i],i);
      instruments[i].setCanvas(canvas[i][0],canvas[i][1],canvas[i][2],canvas[i][3]);
    }
  }
  
  void noteOn(Note node)
  {
    int channel = channels.get(node.channel());
    map.get(channel).put(node.pitch(),node);
  }
  
  void noteOff(Note node)
  {
    
    int channel = channels.get(node.channel());
    map.get(channel).remove(node.pitch());
  }
  
  void draw()
  {
    for(int i = 0; i<instruments.length; i++)
    {
      noFill();
      stroke(255);
      rect(canvas[i][0],canvas[i][1],canvas[i][2]-canvas[i][0],canvas[i][3]-canvas[i][1]);
      
      instruments[i].draw((Note[])map.get(i).values().toArray(new Note[0]));
    }
  }
}