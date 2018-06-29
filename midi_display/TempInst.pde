class TempInst extends BasicInst
{
  int max;
  
  TempInst(int max_)
  {
    super("");
    max = max_;
  }
  
  void draw(Note[] notes)
  {
    for(int i = 0; i < notes.length; i++)
    {
      int pitch = notes[i].pitch();
      if(!n.hasValue(pitch))
      {
        n.append(pitch);
        addBlock();
        if(n.size()>max)
        {
          n.remove(0);
          removeBlock();
        }
      }
    }
    n.sort();
    
    for(int i = 0; i < notes.length; i++)
    {
      int pitch = notes[i].relativePitch()%12;
      int velocity = notes[i].velocity();
      int j=0;
      for(;j<n.size();j++)
        if(n.get(j)==notes[i].pitch())
          break;
      
      blocks.get(j)
        .setColor(color(c[pitch][0],c[pitch][1],c[pitch][2]))
        .setAlpha(velocity)
      ;
    }
    
    displayBlocks(); 
  }
}