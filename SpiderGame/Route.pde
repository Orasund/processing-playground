class Route
{
  //Line[] lines;
  PVector[] points;
  PVector start;
  PVector end;
  int onLine;
  Route(PVector[] points_)
  {
    points = new PVector[points_.length];
    for(int i=0;i<points_.length;i++)
    {
      points[i] = points_[i].copy();
    }
    start = points_[0];
    end = points_[points_.length-1];
    onLine = 0;
  }
  void randomize()
  {
    for(int i=1;i<points.length-1;i++)
    {
      int $size = 30;
      points[i].x += -$size+random(2*$size);
      points[i].y += -$size+random(2*$size);
    }
  }  
  Route copy()
  {
    Route out = new Route(points);
    return out;
  }
  PVector move(float x, float y, float speed)
  {
    PVector out = new PVector(x,y);
    Line $line = new Line(points[onLine],points[onLine+1]);
    if(out == $line.end())
      return out;
    out.add(PVector.mult($line.dir(),speed));
    if(PVector.sub(out,$line.pos()).mag()>=$line.length)
    {
      out.set($line.end());
      onLine++;
      int $max = points.length-2;
      if(onLine>$max)
        onLine = $max;
    }
    return out;
  }
}