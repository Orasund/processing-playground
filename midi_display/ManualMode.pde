class ManualMode
{
  float t;
  float bpm;
  float offset;
  float steping_time;
  int[][] pattern;
  int step;
  Brain brain;
  
  ManualMode(float bpm_, int[][] pattern_ , Brain brain_)
  {
    brain = brain_;
    t=0;
    bpm = bpm_;
    steping_time = 60000/bpm;
    offset = millis();
    step=pattern_[0].length-1;
    pattern = pattern_;
    sendNoteOn();
  }
  
  void sendNoteOn()
  {
    for(int i = 0; i<pattern.length; i++)
    {
      if(pattern[i][step] == 0)
        continue;
      int channel = i;
      int pitch = pattern[i][step];
      int velocity = 257;
      brain.noteOn(new Note(channel,pitch,velocity));
    }
  }
  
  void sendNoteOff()
  {
    for(int i = 0; i<pattern.length; i++)
    {
      if(pattern[i][step] == 0)
        continue;
      int channel = i;
      int pitch = pattern[i][step];
      int velocity = 257;
      brain.noteOff(new Note(channel,pitch,velocity));
    }
  }
  
  boolean tick()
  {
    if(millis()-offset>t*steping_time)
    {
      t++;
      sendNoteOff();
      step = (step+1)%pattern[0].length;
      sendNoteOn();
      return true;
    }
    return false;
  }
}