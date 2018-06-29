public class TimeMaster
{
  float tolerance;
  int bar_size;
  final int[] pattern = {1,0,4,0,2,3,0,0};
  int[] combo = {2,3,2}; //2,3,4 possible
  
  int default_bpm;
  int bpm;
  int time;
  float bar_length; //in millisek
  int bar_position;
  int last_beat;
  int beat_count;
  int offset;
  int combo_count;
  boolean comboing;
  boolean awaiting_input;
  boolean pressed;
  
  TimeMaster(int bpm_)
  {
    bar_size = 4*8;
    tolerance = 250;//500;
    
    default_bpm = bpm_;
    restart();
  }
  
  public void faster()
  {
    setBPM(bpm+10);
    println(bpm);
    reset();
  }

  public void reset()
  {
    time = 0;
    offset = 0;
    bar_position = 0;
    awaiting_input = false;
    pressed = false;    
    comboing = false;
    beat_count = 0;
    last_beat = 0;
  }
  
  public void restart()
  {
    setBPM(default_bpm);
    reset();
  }
  
  public void setBPM(int bpm_)
  {
    bpm = bpm_;
    bar_length = (60*1000)/bpm;
  }
  
  public boolean isOnBeat()
  {
    boolean out = true;
    if(time > beat_count*bar_length)
      out = false;
    else if(time+tolerance < beat_count*bar_length)
      out = false;
    return out;
  }
  
  public void tick()
  {
    if(offset == 0)
      return;
    
    time = millis() - offset;
    
    if(awaiting_input && !isOnBeat())
    {
      
    }

    if(beat_count*bar_length<=time)
    { 
      beat_count++;
      bar_position=(bar_position+1)%bar_size;
      
      awaiting_input = false;
      if(comboing)
      {
        /********/
        println("comboing");
        /********/

        boolean found = false;
        for(int i = 0; i<inputHandler.keys[combo[combo_count]].length; i++)
          if(inputHandler.keys[combo[combo_count]][i] == key)
          {
            found = true;
            break;
          }
        
        if(found)
        {
          /*********/
          println("HIT");
          /*********/
          switch(combo[combo_count])
          {
            case 3:
              low.trigger();
            case 2:
              mid.trigger();
            case 4:
            default:
              high.trigger();
          }
          enemy.looseHealth(1);
          combo_count++;
          if(combo_count>=combo.length)
            comboing = false;
        }
        else
        {
          comboing = false;
          kick.trigger();
          player.startTumbling();
        }
      }
      else      
        switch(pattern[(bar_position+7)%8])
        //switch(bar_position%8)
        {
          case 1://Attack
            attack();
            break;
          case 2://Block
            block();
            break;
          case 3://special
            special();
            break;
          case 4://heal
            heal();
            break;
          case 0:
          default:
            rest();
            break;
        }
      
      pressed = false;
    }
    else if(!awaiting_input && isOnBeat())
    {
      awaiting_input = true;
    }
  }
  
  public void startBeat()
  {
    offset = millis();
  }
  
  public int GetBeatCount()
  {
    return beat_count;
  }
}