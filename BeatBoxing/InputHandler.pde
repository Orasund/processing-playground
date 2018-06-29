public class InputHandler
{
  final char[][] keys = {{},{'w','W'},{'s','S'},{'d','D'},{'a','A'}};

  InputHandler()
  {    
  }

  boolean isCorrectKey()
  {
    return isCorrectKey(0);
  }

  boolean isCorrectKey(int t)
  {
    int pos = (timeMaster.bar_position + 8 + t)%8;
    for(int i = 0; i<keys[timeMaster.pattern[pos]].length; i++)
      if(keys[timeMaster.pattern[pos]][i] == key)
        return true;
    return false; 
  }

  void keyPressed()
  {
    if(timeMaster.offset == 0)
    {
      for(int i = 0; i<keys[1].length; i++)
        if(keys[1][i] == key)
        {
          timeMaster.startBeat();
          break;
        }
      return;
    }

    println(timeMaster.bar_position%8 + " " + key);
    
    timeMaster.pressed = true;
    if(timeMaster.comboing)
    {
      /*int pos = timeMaster.combo[combo_count];
      boolean found = false;
      for(int i = 0; i<keys[pos].length; i++)
        if(keys[pos][i] == key)
        {
          found = true;
          break;
        }
      
      if(found == false)
      */
    }
    else
    if(isCorrectKey() == false)
      player.startTumbling();
  }
}