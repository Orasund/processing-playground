class Player
{
  PVector pos;
  boolean hasLine;
  PVector line;
  int onLine;
  float energie;
  int health;
  int max_health;
  int max_energie;
  Player(float x_,float y_)
  {
    pos = new PVector(x_,y_);
    hasLine = false;
    line = new PVector(0,0);
    onLine=0;
    max_energie=100;
    max_health=3;
    energie=max_energie;
    health=max_health;
  }
  Player copy()
  {
    Player out = new Player(pos.x,pos.y);
    out.hasLine = hasLine;
    out.line.set(line);
    out.onLine = onLine;
    out.energie = energie;
    return out;
  }
  
  void draw(boolean inverted, boolean ongoingWave)
  {
    if(hasLine)
    {
      //draw Line
      Line $line = new Line(line,pos);
      /*PVector $l = new PVector(x-line_x,y-line_y,);
      while()
      {
        if(level.canMoveTo(int(player.x+x),int(player.y+y)))
          //TODO
      }*/
      if($line.length > 150)
        hasLine = false;
      else
        $line.draw(inverted);
    }
    
    //Draw Player
    int $size = 10;
    if(inverted)
      fill(250);
    else if(ongoingWave)
      fill(0);
    else
      fill(255,0,0);
    noStroke();
    ellipse(pos.x,pos.y,$size,$size);
    
    //Draw Energie
    fill(255);
    rect(2,2,energie,10);
    if(max_energie>energie)
    {
      fill(127,127,127);
      rect(2+energie,2,max_energie-energie,10);
    }
    
    //Draw health
    fill(color(255,0,0));
    rect(2,14,(health*100)/max_health,10);
  }
}