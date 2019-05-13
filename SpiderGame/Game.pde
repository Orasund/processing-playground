class Game
{
  Level level;
  Player player;
  int wave;
  boolean ongoingWave;
  
  Game(Level level_,Player player_)
  {
    level = level_.copy();
    player = player_.copy();
    ongoingWave = false;
    wave = 1;
  }
  
  void draw()
  {
    if(player.hasLine)
      background(0);
    else
      background(color(128,128,128));
    fill(0);
    stroke(0);
    level.draw(player.hasLine);
    player.draw(player.hasLine,ongoingWave);
    fill(255);
    text("Wave: "+wave, 2, 35);
  }
  
  boolean isLineAtPlayer()
  {
    return level.isLineAt(int(player.pos.x),int(player.pos.y))!=0;
  }
  
  void movePlayer(int x, int y)
  {
    if(ongoingWave)
      return;
    if(player.pos.x+x>=W)
    {
      player.pos.x=W;
      return;
    }
    if(player.pos.y+y>=H)
    {
      player.pos.y=H;
      return;
    }
    
    if(player.onLine!=0)
    {
      //move on the Line
      int i = player.onLine-1;
      PVector $line = level.lines.get(i).dir();
      
      if(y==0 && level.lines.get(i).x1>level.lines.get(i).x2)
        x*=-1;
      if(x==0 && level.lines.get(i).y1>level.lines.get(i).y2)
        y*=-1;
        
      player.pos.add(PVector.mult($line,x+y)); //x or y is 0
      
      PVector start = level.lines.get(i).end().copy();
      PVector end = level.lines.get(i).pos().copy();
      if((y==0 && x>0) || (x==0 && y>0))
      {
        start.set(level.lines.get(i).pos());
        end.set(level.lines.get(i).end());
      }
        
      $line = PVector.sub(start,player.pos);
      if($line.mag()>level.lines.get(i).length)
      {
          player.pos.set(end);
          player.onLine=0;
      }
    }//END IF(Player.onLine!=0)
    else if(level.canMoveTo(int(player.pos.x+x),int(player.pos.y+y)))
      player.pos.add(new PVector(x,y));
    else
    {
      int i = level.isLineAt(int(player.pos.x),int(player.pos.y));
      if(i!=0)
      {
        player.onLine = i;
        //set player on Line
        PVector $pos = level.lines.get(i-1).pos().copy();
        float $length = PVector.sub(player.pos,$pos).mag();
        player.pos.set(PVector.add($pos,level.lines.get(i-1).dir().mult($length)));
      }
    }
  }
  
  void placeLineAtPlayer()
  {
    if(ongoingWave)
      return;
    PVector $pos = player.pos.copy();
    if(level.isLineAt(int($pos.x),int($pos.y)) != 0 || player.onLine != 0)
      return;
    if(player.hasLine)
    {
      if(level.placeLineAt(player.line,$pos))
        player.energie-=10;
    }
    else
    {
      if(player.energie<10)
        return;
      player.line.set($pos);
    }
    player.hasLine = !player.hasLine;
  }
  
  void startWave()
  {
    ongoingWave = true;
    level.addMonsters(wave);
  }
  
  void endWave()
  {
    ongoingWave = false;
    wave++;
  }
  
  void tick()
  {
    if(ongoingWave == false)
      return;
    if(level.objects.size()==0 && level.waitingEnemys==0)
      endWave();
    else
      level.tick(wave);
  }
  
}