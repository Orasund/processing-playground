class BaseInst extends BasicInst
{
  private int kick = toNote("c",1); //c2
  private int snare = toNote("d",1); //d2
  private int clap = toNote("d#",1); //D#2
  private int hihat = toNote("f#",1);//F#2
  private boolean last_clap = false;
  private boolean clap_bool = false;
  
  BaseInst()
  {
    super("");
  }
  
  void draw(Note[] notes)
  {
    if(blocks.size()<3)
    {
      blocks.add(new Block(l,t,w,h/2,colorScheme(0),delay));          //Kick
      blocks.add(new Block(l,t+h/2,w,h/4,colorScheme(3),delay));      //Snare
      blocks.add(new Block(l,t+(3*h)/4,w/2,h/4,colorScheme(7),delay));//Clap
    }
    
    boolean is_clap = false;
    for(int i = 0; i < notes.length; i++)
    {
      int alpha = notes[i].velocity();
      if(notes[i].pitch() == kick)
      {
        blocks.get(0).setAlpha(alpha);
      }
      else if(notes[i].pitch() == snare)
        blocks.get(1).setAlpha(alpha);
      else if(notes[i].pitch() == clap)
      {
        blocks.get(2).setAlpha(alpha);
        if(!last_clap)
        {
          if(clap_bool)
            blocks.get(2).moveTo(l+w/2,t+(3*h)/4,w/2,h/4);
          else
            blocks.get(2).moveTo(l,t+(3*h)/4,w/2,h/4);
          clap_bool = !clap_bool;
        }
        is_clap = true;
      }
    }
    last_clap = is_clap;
    
    displayBlocks();
    fill(#FFFFFF);
    textSize(w/4);
    text("Kick", l+w/2, t+h/4+w/8);
    text("Snare", l+w/2, t+h/2+h/8+w/8); 
    text("Clap", l+w/2, t+(3*h)/4+h/8+w/8);
  }
}