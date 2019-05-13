class Level
{
  Wall[] walls;
  ArrayList<Fly> objects;
  Fly[] enemys;
  int waitingEnemys;
  int counter;
  ArrayList<Line> lines;
  Level(Wall[] walls_, Fly[] enemys_)
  {
    waitingEnemys = 0;
    counter = 0;
    walls = new Wall[walls_.length];
    for(int i=0;i<walls_.length;i++)
    {
      walls[i] = walls_[i].copy();
    }
    
    enemys = new Fly[enemys_.length];
    for(int i=0;i<enemys_.length;i++)
    {
      enemys[i] = enemys_[i].copy();
    }
    
    objects = new ArrayList<Fly>();
    lines = new ArrayList<Line>();    
  }
  Level copy()
  { 
    Level out = new Level(walls,enemys);
    out.waitingEnemys = waitingEnemys;
    for(int i=0;i<lines.size();i++)
    {
      out.addLine(lines.get(i));
    }
    return out;
  }
  void draw(boolean inverted)
  {
    for(int i = 0; i < walls.length; i++)
    {
      walls[i].draw(inverted);
    }
    for(int i = 0; i < lines.size(); i++)
    {
      lines.get(i).draw(inverted);
    }
    for(int j=objects.size()-1;j>=0;j--)
    {
      objects.get(j).draw(inverted);
    }
  }
  
  boolean placeLineAt(PVector start, PVector end)
  {
    Line $line = new Line(start,end);    
    if
    (
      $line.length > 30 &&
      $line.pos().x != $line.end().x &&
      $line.pos().y != $line.end().y
    )
    {
      addLine($line);
      return true;
    }
    else
    {
      return false;
    }
  }
  
  void tick(int wave)
  {
    if(waitingEnemys>0)
    {
      counter++;
      if(counter>=60)
      {
        counter=0;
        addMonster(wave);
        waitingEnemys--;
      }
    }
    
    for(int j=objects.size()-1;j>=0;j--)
    {
      if(objects.get(j).isAtEnd()==false)
        objects.get(j).move();
      else
      {
        objects.remove(j);
        game.player.health--;
        break;
      }
      
      //fly breaks lines that it touches
      for(int i=0;i<lines.size();i++)
      {
        Line $line = lines.get(i).copy();
        if(!$line.visible)
          continue;
        PVector $v = PVector.sub(objects.get(j).pos,$line.pos());
        float $a = PVector.angleBetween($v, $line.dir());
        if($v.mag() > $line.length || $a > PI/2 || $a == 0)
          continue;
        $line = null;
        if($v.mag()*sin($a)<3)
        {
          objects.get(j).speed-=0.5;
          if(objects.get(j).speed <= 0)
          {
            for(int k=lines.size()-1;k>=0;k--)
              lines.get(k).visible = true;
            game.player.energie+=10*((objects.get(j).max_speed)*2);
            objects.remove(j);
            break;
          }
          objects.get(j).lines.add(lines.get(i).copy());
          if((150*objects.get(j).speed)/lines.get(i).length<1)
            lines.get(i).visible = false;
          else
            lines.remove(i);
        }
      }
    }
  }
  
  int isLineAt(int x, int y)
  {
    int out = 0;
    for(int i=0;i<lines.size();i++)
    {
      int $tolerance = 10;
      if
      (
        (
          (lines.get(i).x1-x)*(lines.get(i).x1-x) <= $tolerance 
          && (lines.get(i).y1-y)*(lines.get(i).y1-y) <= $tolerance
        )
        ||(
          (lines.get(i).x2-x)*(lines.get(i).x2-x) <= $tolerance
          && (lines.get(i).y2-y)*(lines.get(i).y2-y) <= $tolerance
        )
      )
      {
        out = i+1;
        break;
      }
    }
    return out;
  }
  
  boolean canMoveTo(int x,int y)
  {
    //is a Line at players position
    
    //isWall at (x,y)
    boolean out = false;
    for(int i=0;i<walls.length;i++)
    {
      if
      (
        (walls[i].x<=x && walls[i].x+walls[i].w>=x && walls[i].y==y)
        ||(walls[i].x<=x && walls[i].x+walls[i].w>=x && walls[i].y+walls[i].h==y)
        ||(walls[i].y<=y && walls[i].y+walls[i].h>=y && walls[i].x==x)
        ||(walls[i].y<=y && walls[i].y+walls[i].h>=y && walls[i].x+walls[i].w==x)
      )
      {
        out = !out;
        if(
           (walls[i].x==x && walls[i].y==y)
           || (walls[i].x==x && walls[i].y+walls[i].h==y)
           || (walls[i].x+walls[i].w==x && walls[i].y==y)
           || (walls[i].x+walls[i].w==x && walls[i].y+walls[i].h==y)
        )
        {
          out = true;
          break;
        }
        if(out==false)
          break;
      }
    }
    return out;
  }
  
  void addLine(Line line)
  {
   lines.add(line.copy());
  }
  
  void addMonsters(int wave)
  {
    waitingEnemys = wave;
  }
 
  void addMonster(int wave)
  {
    int $max;
    if(wave > enemys.length)
      $max = enemys.length;
    else
      $max = wave;
    int $random = floor(random($max));
    objects.add(enemys[$random].copy());
    objects.get(objects.size()-1).route.randomize();
  }
}