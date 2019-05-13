class Line
{
  int x1;
  int x2;
  int y1;
  int y2;
  float length;
  boolean visible;
  /*Line(int x1_, int y1_, int x2_, int y2_)
  {
    x1 = x1_;
    x2 = x2_;
    y1 = y1_;
    y2 = y2_;
    length = sqrt((x1-x2)*(x1-x2)+(y1-y2)*(y1-y2));
  }*/
  Line(PVector start, PVector end)
  {
    x1 = int(start.x);
    y1 = int(start.y);
    x2 = int(end.x);
    y2 = int(end.y);
    length = PVector.sub(end,start).mag();
    visible = true;
  }
  Line copy()
  {
    Line out = new Line(new PVector(x1,y1),new PVector(x2,y2));
    out.visible = visible;
    return out;
  }
  PVector end()
  {
    return new PVector(x2,y2);
  }
  PVector pos()
  {
    PVector out = new PVector(x1,y1);
    return out;
  }
  PVector dir()
  {
    PVector out = new PVector(x2-x1,y2-y1);
    out.setMag(1);
    return out;
  }
  void draw(boolean inverted)
  {
    if(visible == false)
     return;
    fill(0);
    if(inverted)
      stroke(255);
    else
      stroke(255);
      //stroke(color(128,128,128));
    int $l = 70;//max=150
    if(length<$l)
      strokeWeight(1.5);
    else
      strokeWeight(70/length);
    line(x1,y1,x2,y2);
  }
}