class Fly
{
  Route route;
  int onLine;
  PVector pos;
  ArrayList<Line> lines;
  float speed;
  float max_speed;
  Fly(Route route_, float max_speed_)
  {
    route = route_.copy();
    route.onLine = 0;
    pos = route.start.copy();
    max_speed = max_speed_;
    speed = max_speed;
    lines = new ArrayList<Line>();
  }
  
  Fly copy()
  {
    Fly out = new Fly(route,max_speed);
    out.onLine = 0;
    out.pos = pos.copy();
    out.speed = speed;
    return out;
  }
  
  void move()
  {
    if(speed<=0)
      return;
    pos.set(route.move(pos.x,pos.y,speed));
  }
  
  boolean isAtEnd()
  {
    return (pos.x == route.end.x && pos.y == route.end.y);
  }
  
  void draw(boolean inverted)
  {
    int $size = floor(3*max_speed);
    for(int i=lines.size()-1;i>=0;i--)
    {
      Line $line1 = new Line(lines.get(i).pos(),pos);
      Line $line2 = new Line(pos,lines.get(i).end());
      if($line1.length+$line2.length < 150)
      {
        $line1.draw(inverted);
        $line2.draw(inverted);
      }
      else
      {
        lines.remove(i);
      }
      $line1 = null;
      $line2 = null;
    }
    if(inverted)
      fill(250);
    else
      fill(255*(1-speed/max_speed),255*(1-speed/max_speed),255);
    noStroke();
    ellipse(pos.x,pos.y,$size,$size);
  }
}