class SmartInst extends BasicInst
{ 
  SmartInst(String str)
  {
    super(str);
  }
  
  void draw(Note[] notes)
  {
    for(int i = 0; i < notes.length; i++)
    {
      int pitch = notes[i].relativePitch();
      if(!n.hasValue(pitch))
      {
        n.append(pitch);
        addBlock();
      }
    }
    n.sort();
    
    for(int i = 0; i < notes.length; i++)
    {
      int pitch = notes[i].relativePitch();
      int velocity = notes[i].velocity();
      int j=0;
      for(;j<n.size();j++)
        if(n.get(j)==pitch)
          break;
      
      blocks.get(j)
        .setColor(color(c[pitch%12][0],c[pitch%12][1],c[pitch%12][2]))
        .setAlpha(velocity)
      ;
    }
    
    displayBlocks();
    textSize(h);
    fill(0);
    text(name, l+w/2, t+(7*h)/8); 
  }
}